//
//  Day_Convenience.swift
//  Habit Tracker
//
//  Created by Lambda_School_Loaner_214 on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Day {
    convenience init (date: Date = Date(), status: DayStatus = .unset, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.status = status.rawValue
        self.date = date
    }
}
