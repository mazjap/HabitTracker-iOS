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
let debuging: Bool = false
let testing: Bool = false

extension UIColor {
    static var htBackground: UIColor = {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        }
    }()
    
    static let htTextColor = UIColor(red: 254.0 / 255.0, green: 220.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
    static let htCalenderCell = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)
    static let htCalendarYes = UIColor.green
    static let htCalendarNo = UIColor.red
    static let htCalendarUnk = UIColor.lightGray
    
    static var borderColor: UIColor = {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        }
    }()
}
