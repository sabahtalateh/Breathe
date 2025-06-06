import Testing
import SwiftData
@testable import Breathe

struct ExerciseTests {
    
    // Test for creating an Exercise object
//    @Test func testExerciseCreation() throws {
//        let exercise = Exercise(order: 1, title: "Test Exercise")
//        
//        #expect(exercise.order == 1)
//        #expect(exercise.title == "Test Exercise")
//    }
//    
//    // Test for ID uniqueness
//    @Test func testExerciseIdUniqueness() throws {
//        let exercise1 = Exercise(order: 1, title: "Exercise 1")
//        let exercise2 = Exercise(order: 2, title: "Exercise 2")
//        
//        #expect(exercise1.id != exercise2.id)
//    }
}

struct ExerciseAdditionTests {
    
//    // Test for adding an exercise to an empty container
//    @MainActor @Test func testAddExerciseToEmptyContainer() throws {
//        
//        // Create an in-memory test container
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: Exercise.self, configurations: config)
//        let context = container.mainContext
//        
//        // Verify the container is empty
//        let initialExercises = try context.fetch(FetchDescriptor<Exercise>())
//        #expect(initialExercises.isEmpty)
//        
//        // Add some exercises
//        let exercise = Exercise(order: 0, title: "First Exercise")
//        context.insert(exercise)
//        
//        let exercise2 = Exercise(order: 1, title: "Second Exercise")
//        context.insert(exercise2)
//        
//        // Verify the exercises was added
//        let exercises = try context.fetch(FetchDescriptor<Exercise>())
//        #expect(exercises.count == 2)
//    }
}
