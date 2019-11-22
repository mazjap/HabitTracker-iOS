//
//  Habit_TrackerTests.swift
//  Habit TrackerTests
//
//  Created by Lambda_School_Loaner_214 on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import XCTest
import CoreData
@testable import Habit_Tracker

class HabitTrackerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testCreateNewHabit() {
        let count = fetchHabits().fetchedObjects?.count ?? 0
        let title = "Title"
        let desc = "Desc"
        let goalDays: Int64 = 21
        HabitController.shared.add(title: title, desc: desc, goalDays: Int(goalDays), notify: false, notifyTime: Date())
        guard let habits = fetchHabits().fetchedObjects,
            let habit = habits.last else { XCTFail("Habits could not be fetched"); return }
        XCTAssertNotEqual(habits.count, count)
        XCTAssertEqual(habit.title, title)
        XCTAssertEqual(habit.desc, desc)
        XCTAssertEqual(habit.goalDays, goalDays)
    }
    
    func fetchHabits() -> NSFetchedResultsController<Habit> {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self as? NSFetchedResultsControllerDelegate
        do {
            try frc.performFetch()
        } catch {
            fatalError("Unable to fetch object: \(error)")
        }
        
        return frc
    }
}
