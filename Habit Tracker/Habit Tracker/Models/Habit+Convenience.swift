//
//  Habit_Convenience.swift
//  Habit Tracker
//
//  Created by Lambda_School_Loaner_214 on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Habit {
    convenience init (title: String,
                      desc: String,
                      goalDays: Int,
                      notify: Bool,
                      notifyTime: Date,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = UUID()
        self.title = title
        self.desc = desc
        self.goalDays = Int64(goalDays)
        if testData {
            self.startDate = Date().minus(weeks: 1)
        } else {
            self.startDate = Date()
        }
        self.notify = notify
        self.notifyTime = notifyTime
        self.lastUpdated = Date()
    }
    
    func getDay(with date: DateComponents) -> Day? {
        guard let daysArr = self.days?.allObjects as? [Day] else { return nil }
        let arr = daysArr.filter({ Calendar.current.dateComponents([.day, .month, .year], from: $0.date ?? Date(timeIntervalSince1970: 0)) == date })
        return arr.first
    }
}
