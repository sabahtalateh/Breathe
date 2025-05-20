import SwiftUI
import SwiftData

@main
struct BreatheApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Exercise.self,
        ])
        
        // Check if we're running UI tests with the clear exercises flag
        let isUITestingWithClearExercises = ProcessInfo.processInfo.environment[TestConstants.clearExercises] == "1"
        
        // Use in-memory storage for UI tests to prevent persistence
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isUITestingWithClearExercises
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
    }
}
