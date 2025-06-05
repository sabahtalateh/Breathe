import SwiftUI
import SwiftData

@main
struct BreatheApp: App {
    
    var sharedModelContainer: ModelContainer = {
        
        let schema = Schema([
            Exercise.self,
            ConstantTrack.self,
            DynamicTrack.self,
            CustomTrack.self,
            CustomTrackStep.self,
            CustomTrackStep.self
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
            print("❗ Error: \(error)")
            print("🛠️ Try clean application directories")
            printApplicationPaths()
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        printApplicationPaths()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
    }
}

private func printApplicationPaths() {
    let fileManager = FileManager.default
    
    // Application Support Directory
    if let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
        print("📁 Application Support Directory: \(appSupportURL.path)")
    }
    
    // Documents Directory
    if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
        print("📄 Documents Directory: \(documentsURL.path)")
    }
    
    // Library Directory
    if let libraryURL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first {
        print("📚 Library Directory: \(libraryURL.path)")
    }
    
    // Caches Directory
    if let cachesURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
        print("💾 Caches Directory: \(cachesURL.path)")
    }
    
    // Temporary Directory
    let tempURL = fileManager.temporaryDirectory
    print("🗂️ Temporary Directory: \(tempURL.path)")
}
