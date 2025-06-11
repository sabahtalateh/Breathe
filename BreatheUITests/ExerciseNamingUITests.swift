import XCTest

final class ExerciseNamingUITests: XCTestCase {
    
    @MainActor
    func testExerciseNamingSequence() throws {
        let app = XCUIApplication()
        app.launchArguments.append(UITestFlags.inMemoryStorage)
        app.launch()
        
        // Initial state - no exercises
        XCTAssertEqual(app.cells.count, 0)
        
        // Add first exercise
        app.buttons["Add Exercise"].tap()
        app.buttons["Add Exercise"].tap()
        app.buttons["Add Exercise"].tap()
        
        XCTAssertEqual(app.cells.count, 3)
        
        // Get text from first exercise button
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 0) == "New Exercise")
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 1) == "New Exercise 2")
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 2) == "New Exercise 3")
    }
    
    @MainActor
    func testExerciseNamingAfterDeletion() throws {
        let app = XCUIApplication()
        app.launchArguments.append(UITestFlags.inMemoryStorage)
        app.launch()
        
        // Add three exercises
        app.buttons["Add Exercise"].tap()
        app.buttons["Add Exercise"].tap()
        app.buttons["Add Exercise"].tap()
        
        XCTAssertEqual(app.cells.count, 3)
        
        // Check initial exercise names
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 0) == "New Exercise")
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 1) == "New Exercise 2")
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 2) == "New Exercise 3")
        
        // Delete the middle exercise "New Exercise 2"
        let secondCell = app.cells.element(boundBy: 1)
        secondCell.swipeLeft()
        app.buttons["Delete"].tap()
        
        // Add another exercise - should be "New Exercise 4" (not filling the gap)
        app.buttons["Add Exercise"].tap()
        XCTAssertEqual(app.cells.count, 3)
        
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 0) == "New Exercise")
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 1) == "New Exercise 3")
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 2) == "New Exercise 4")
    }
    
    @MainActor
    func testExerciseNamingWithCustomNames() throws {
        let app = XCUIApplication()
        app.launchArguments.append(UITestFlags.inMemoryStorage)
        app.launch()
        
        // Add first exercise
        app.buttons["Add Exercise"].tap()
        
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 0) == "New Exercise")
        
        // Tap on the exercise to open detail view
        let firstCell = app.cells.element(boundBy: 0)
        let firstExerciseButton = firstCell.buttons.element(boundBy: 0)
        firstExerciseButton.tap()
        
        // Wait for navigation to detail view
        XCTAssertTrue(app.navigationBars["New Exercise"].waitForExistence(timeout: 2))
        
        // Find and edit the exercise title
        let titleField = app.textFields["Exercise Title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        
        // Clear and enter new title
        titleField.tap()
        titleField.clearAndEnterText("Updated")
        
        // Go back to list
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Wait for navigation back to list
        XCTAssertTrue(app.navigationBars["Exercises"].waitForExistence(timeout: 2))
        
        // Add another exercise - should still be "New Exercise 2"
        app.buttons["Add Exercise"].tap()
        XCTAssertEqual(app.cells.count, 2)
        
        // Check first exercise (should now be "Custom Exercise")
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 0) == "Updated")

        // Check second exercise (should be "New Exercise")
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 1) == "New Exercise")
    }
    
    @MainActor
    func testExerciseNamingWithCustomNames2() throws {
        let app = XCUIApplication()
        app.launchArguments.append(UITestFlags.inMemoryStorage)
        app.launch()
        
        // Add first exercise
        app.buttons["Add Exercise"].tap()
        
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 0) == "New Exercise")
        
        // Tap on the exercise to open detail view
        let firstCell = app.cells.element(boundBy: 0)
        let firstExerciseButton = firstCell.buttons.element(boundBy: 0)
        firstExerciseButton.tap()
        
        // Wait for navigation to detail view
        XCTAssertTrue(app.navigationBars["New Exercise"].waitForExistence(timeout: 2))
        
        // Find and edit the exercise title
        let titleField = app.textFields["Exercise Title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        
        // Clear and enter new title
        titleField.tap()
        titleField.clearAndEnterText("New Exercise 999")
        
        // Go back to list
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Wait for navigation back to list
        XCTAssertTrue(app.navigationBars["Exercises"].waitForExistence(timeout: 2))
        
        // Add another exercise - should still be "New Exercise 2"
        app.buttons["Add Exercise"].tap()
        XCTAssertEqual(app.cells.count, 2)
        
        // Check first exercise (should now be "Custom Exercise")
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 0) == "New Exercise 999")

        // Check second exercise (should be "New Exercise")
        XCTAssertTrue(getExerciseName(from: app, cellIndex: 1) == "New Exercise 1000")
    }
    
    // Helper function to get exercise name from cell
    private func getExerciseName(from app: XCUIApplication, cellIndex: Int) -> String {
        let cell = app.cells.element(boundBy: cellIndex)
        let exerciseButton = cell.buttons.element(boundBy: 0)
        return exerciseButton.label
    }
}

extension XCUIElement {
    func clearAndEnterText(_ text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non-string value")
            return
        }
        
        self.tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
}
