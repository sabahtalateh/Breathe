import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Exercise.order) private var exercises: [Exercise]

    @State private var selectedExercise: Exercise?
    
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn

    var body: some View {
        VStack {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                ExerciseListView(selectedExercise: $selectedExercise)
                    .navigationTitle("Exercises")
            } detail: {
                if let exercise = selectedExercise {
                    ExerciseDetailView(exercise: exercise)
                } else {
                    Text("Select an exercise")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationSplitViewStyle(.balanced)
            .tint(.white)
        }
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
