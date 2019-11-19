//
//  LocalNotificationManager.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class LocalNotificationManager {
    var notifications = [Notification]()

}

struct Notification {
    var id: String
    var title: String
    var datetime: DateComponents
}
