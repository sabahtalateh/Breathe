import SwiftUI
import SwiftData

struct ExerciseListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Exercise.order) private var exercises: [Exercise]
    
    @Binding var selectedExercise: Exercise?
    
    @Binding var showPlayer: Bool
    
    @State private var presentDestination: Bool = false
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        
        ZStack {
            
            // Material background
            Rectangle()
                .fill(.thinMaterial)
                .ignoresSafeArea()
            
            ScrollViewReader { scroller in
                List {
                    ForEach(exercises) { exercise in
                        Button {
                            selectedExercise = exercise
                            presentDestination = true
                        } label: {
                            HStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                Text(exercise.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .listRowBackground(Color.clear)
                        .id(exercise.id)
                    }
                    .onDelete(perform: deleteExercises)
                    .onMove(perform: moveExercises)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .navigationDestination(isPresented: $presentDestination, destination: {
                    if let exercise = selectedExercise {
                        ExerciseDetailView(
                            exercise: exercise,
                            showPlayer: $showPlayer
                        )
                            .onDisappear {
                                selectedExercise = nil
                            }
                    } else {
                        Text("No Exercise Selected")
                    }
                })
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                isEditing.toggle()
                            }
                        } label: {
                            Image(systemName: isEditing ? "checkmark" : "pencil")
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .accessibilityIdentifier("Edit Exercises")
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            addExercise(scroller: scroller)
                        } label: {
                            Label("Add Exercise", systemImage: "plus")
                        }
                        .accessibilityIdentifier("Add Exercise")
                    }
                }
            }
            
        }
    }
    
    private func addExercise(scroller: ScrollViewProxy) {
        let maxOrder = exercises.map(\.order).max() ?? -1
        let new = Presets.exercises.defaultConstant(order: maxOrder + 1, title: "Test Exercise")
        
        withAnimation {
            modelContext.insert(new)
            try? modelContext.save()
        }
        
        // Scroll not works without explicit waiting
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation {
                scroller.scrollTo(new.id, anchor: .bottom)
            }
        }
    }
    
    private func deleteExercises(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(exercises[index])
        }
    }
    
    private func moveExercises(from source: IndexSet, to destination: Int) {

        var mutableExercises = exercises
        
        mutableExercises.move(fromOffsets: source, toOffset: destination)
        
        for (index, exercise) in mutableExercises.enumerated() {
            exercise.order = index
        }
        
        // try? modelContext.save() (???)
    }
}

#Preview {
    NavigationStack {
        ExerciseListView(
            selectedExercise: .constant(nil),
            showPlayer: .constant(false)
        )
        .modelContainer(for: Exercise.self, inMemory: true) { result in
            if case let .success(container) = result {
                let context = container.mainContext
                for i in 0..<3 {
                    let ex = Presets.exercises.defaultConstant(order: 0, title: "Test Exercise")
                    context.insert(ex)
                }
            }
        }
        .navigationTitle("Exercises")
    }
    .preferredColorScheme(.dark)
    .tint(.primary)
}
