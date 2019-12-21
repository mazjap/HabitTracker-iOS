//
//  Constants.swift
//  Journal
//
//  Created by Joshua Sharp on 9/19/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit


typealias CompletionWithError = (_ error: Error?) -> Void

let userDefaults = UserDefaults.standard
let coreDataModelName: String = "Habit_Tracker"
var devSettings = userDefaults.bool(forKey: "devSettings")
var devNotifications = userDefaults.bool(forKey: "devNotifications")
var testData = userDefaults.bool(forKey: "testData")

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter
}()
