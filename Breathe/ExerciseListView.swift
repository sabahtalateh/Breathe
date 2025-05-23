import SwiftUI
import SwiftData

struct ExerciseListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Exercise.order) private var exercises: [Exercise]
    
    @Binding var selectedExercise: Exercise?
    @State private var presentDestination: Bool = false
    
    var body: some View {
        ZStack {
            
            // Material background
            Rectangle()
                .fill(.thinMaterial)
                .ignoresSafeArea()
            
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
                }
                .onDelete(perform: deleteExercises)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationDestination(isPresented: $presentDestination, destination: {
                if let exercise = selectedExercise {
                    ExerciseDetailView(exercise: exercise)
                        .onDisappear {
                            selectedExercise = nil
                        }
                } else {
                    Text("No Exercise Selected")
                }
            })
        }
        .toolbar {
            // ToolbarItem(placement: .navigationBarTrailing) {
            //     EditButton()
            // }
            ToolbarItem {
                Button(action: addExercise) {
                    Label("Add Exercise", systemImage: "plus")
                }
                .accessibilityIdentifier("Add Exercise")
                .tint(.primary)
            }
            
        }
    }
    
    private func addExercise() {
        let maxOrder = exercises.map(\.order).max() ?? -1
        let new = Exercise(order: maxOrder + 1, title: "Exercise \(maxOrder + 2)")
        modelContext.insert(new)
    }

    private func deleteExercises(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(exercises[index])
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseListView(selectedExercise: .constant(nil))
            .modelContainer(for: Exercise.self, inMemory: true) { result in
                if case let .success(container) = result {
                    let context = container.mainContext
                    for i in 0..<3 {
                        let ex = Exercise(order: i, title: "Exercise \(i + 1)")
                        context.insert(ex)
                    }
                }
            }
            .navigationTitle("Exercises")
    }
    .preferredColorScheme(.dark)
}
