//
//  Habit_TrackerUITests.swift
//  Habit TrackerUITests
//
//  Created by Lambda_School_Loaner_214 on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import XCTest

class HabitTrackerUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        app.launch()
        continueAfterFailure = false
    }

    func testCreateNewHabit() {
        app.tabBars.buttons["Habits"].tap()
        app.navigationBars["My Habits"].buttons["Add"].tap()
        let habitNameTextField = app.textFields["Habit Name"]
        habitNameTextField.tap()
        habitNameTextField.typeText("UI Test")
        
        let habitDescTextField = app.textViews["Other details"]
//        habitDescTextField.tap()
    }
}
