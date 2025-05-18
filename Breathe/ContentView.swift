import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Exercise.order) private var exercises: [Exercise]

    @State private var selectedExercise: Exercise?

    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.thinMaterial)
                    .ignoresSafeArea()
                
                List {
                    ForEach(exercises) { exercise in
                        Button {
                            selectedExercise = exercise
                        } label: {
                            HStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                Text(exercise.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: deleteExercises)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addExercise) {
                        Label("Add Exercise", systemImage: "plus")
                    }
                }
            }
            .navigationDestination(item: $selectedExercise) { exercise in
                ExerciseDetailView(exercise: exercise)
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

struct ExerciseDetailView: View {
    var exercise: Exercise

    var body: some View {
        Text("Exercise: \(exercise.title)")
            .navigationTitle(exercise.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Exercise.self, inMemory: true) { result in
            if case let .success(container) = result {
                let context = container.mainContext
                for i in 0..<3 {
                    let ex = Exercise(order: i, title: "Exercise \(i + 1)")
                    context.insert(ex)
                }
            }
        }
        .preferredColorScheme(.dark)
}
