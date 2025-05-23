import XCTest

final class ExercisesUITests: XCTestCase {
    
    // Add one exercise, check one exercise in list
    // Add two more, check three exercises in list
    @MainActor
    func testAddExercise() throws {
        let app = XCUIApplication()
        app.launchArguments.append(UITestFlags.inMemoryStorage)
        app.launch()
        
        // Initial exercises count is zero
        XCTAssertEqual(app.cells.count, 0)

        // Tap the "Add Exercise" button
        app.buttons["Add Exercise"].tap()

        // Wait and count again
        XCTAssertEqual(app.cells.count, 1)
        
        // Tap the "Add Exercise" button two times
        app.buttons["Add Exercise"].tap()
        app.buttons["Add Exercise"].tap()

        // Wait and count again
        XCTAssertEqual(app.cells.count, 3)
    }
    
    // Add 3 exercise, delete one, check 2 remains
    @MainActor
    func testDeleteExercise() throws {
        let app = XCUIApplication()
        app.launchArguments.append(UITestFlags.inMemoryStorage)
        app.launch()

        // Add three exercises
        app.buttons["Add Exercise"].tap()
        app.buttons["Add Exercise"].tap()
        app.buttons["Add Exercise"].tap()

        // Swipe one to delete
        let cell = app.cells.element(boundBy: 1)
        XCTAssertTrue(cell.waitForExistence(timeout: 2))
        cell.swipeLeft()
        app.buttons["Delete"].tap()

        // Verify two cells remain
        XCTAssertEqual(app.cells.count, 2)
    }
}
