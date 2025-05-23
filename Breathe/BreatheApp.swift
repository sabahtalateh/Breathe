import SwiftUI
import SwiftData

@main
struct BreatheApp: App {
    var sharedModelContainer: ModelContainer = {

        let schema = Schema([
            Exercise.self,
        ])
        
        // Use in-memory storage for UI tests to prevent persistence
        let isInMemory = CommandLine.arguments.contains(UITestFlags.inMemoryStorage)
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isInMemory
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
