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
        // Please make sure "Connect Hardware Keyboard" is disabled in your simulator before running this
        // (Hardware > Keyboard > Connect Hardware Keybard = Disabled)
        
        let title = "UI Test"
        let desc = "Generic Desc"
        
        app.tabBars.buttons["Habits"].tap()
        app.navigationBars["My Habits"].buttons["Add"].tap()
        let habitNameTextField = app.textFields["Habit.Name"]
        habitNameTextField.tap()
        habitNameTextField.typeText(title)
        
        let habitDescTextView = app.textViews["Habit.Description"]
        habitDescTextView.tap()
        habitDescTextView.typeText(desc)
        
        app.buttons["Save"].tap()
        app.tables["MyHabitsTableView"].cells["HabitCell0"].tap()
        
        XCTAssertEqual(title, app.textFields["Habit.Name"].value as? String)
        XCTAssertEqual(desc, app.textViews["Habit.Description"].value as? String)
    }
}
