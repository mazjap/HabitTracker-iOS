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

let coreDataModelName: String = "Habit_Tracker"
let testing: Bool = false

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter
}()
