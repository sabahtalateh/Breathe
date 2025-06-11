import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Exercise.order) private var exercises: [Exercise]
    
    @State private var selectedExercise: Exercise?
    
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    
    @State private var editCustomTrack: Bool = false
    
    @State private var showPlayer = false
    
    var body: some View {
        VStack {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                ExerciseListView(
                    selectedExercise: $selectedExercise,
                    showPlayer: $showPlayer
                )
                .navigationTitle("Exercises")
            } detail: {
                if let exercise = selectedExercise {
                    ExerciseDetailView(
                        exercise: exercise,
                        showPlayer: $showPlayer
                    )
                } else {
                    Text("Select an exercise")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationSplitViewStyle(.balanced)
            .tint(.primary)
        }
        .fullScreenCover(isPresented: $showPlayer) {
            if let exercise = selectedExercise {
                ExercisePlayerView(exercise: exercise, isPresented: $showPlayer)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Exercise.self, inMemory: true) { result in
            if case let .success(container) = result {
                let context = container.mainContext
                for i in 0..<3 {
                    let ex = Presets.exercises.defaultConstant(order: i, title: "Exercise \(i + 1)")
                    context.insert(ex)
                }
            }
        }
        .preferredColorScheme(.dark)
}
