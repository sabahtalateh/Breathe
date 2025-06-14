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
                        .listRowBackground(
                            Color(selectedExercise == exercise ? .black : .clear)
                                .opacity(0.5)
                                .animation(.easeOut(duration: 0.18))
                        )
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
        let new = Presets.exercises.defaultConstant(order: maxOrder + 1, title: generateExerciseTitle())
        
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
    
    private func generateExerciseTitle() -> String {
        let prefix = "New Exercise"
        
        // Get all existing titles that start with prefix
        let existingTitles = exercises.map { exercise in exercise.title }
        let newExerciseTitles = existingTitles.filter { title in title.hasPrefix(prefix) }
        
        // If no "New Exercise" titles exist, return "New Exercise"
        if newExerciseTitles.isEmpty {
            return prefix
        }
        
        // Extract numbers from existing titles
        var existingNumbers: [Int] = []
        for title in newExerciseTitles {
            if title == prefix {
                // "New Exercise" without number = 1
                existingNumbers.append(1)
            } else if title.hasPrefix("\(prefix) ") {
                // Remove "New Exercise " prefix and try to parse the number
                let numberPart = title.trimmingPrefix("\(prefix) ")
                if let number = Int(numberPart) {
                    existingNumbers.append(number)
                }
            }
        }
        
        // Find the next available number
        let maxNumber = existingNumbers.max() ?? 0
        let nextNumber = maxNumber + 1
        
        return "\(prefix) \(nextNumber)"
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
