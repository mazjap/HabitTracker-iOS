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
    convenience init (title: String, desc: String, goalDays: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = UUID()
        self.title = title
        self.desc = desc
        self.goalDays = Int64(goalDays)
        self.startDate = Date()
    }
}
