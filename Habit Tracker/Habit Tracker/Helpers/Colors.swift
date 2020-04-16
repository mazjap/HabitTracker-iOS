//
//  Colors.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 11/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var htBackground: UIColor = {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor(red: 30 / 255, green: 40 / 255, blue: 50 / 255, alpha: 1.0)
            }
        }
    }()
    
    static var htText: UIColor = {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.36, green: 0.73, blue: 0.74, alpha: 1.00)
            } else {
                return UIColor(red: 0.27, green: 0.42, blue: 0.78, alpha: 1.00)
            }
        }
    }()
    
    static var htCalenderCell: UIColor = {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.black
            } else {
                return UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)
            }
        }
    }()
    
    static var htCalendarYes: UIColor = {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.38, green: 0.75, blue: 0.38, alpha: 1.00)
            } else {
                return UIColor.green
            }
        }
    }()
    
    static var htCalendarNo: UIColor = {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.75, green: 0.00, blue: 0.00, alpha: 1.00)
            } else {
                return UIColor.red
            }
        }
    }()
    
    static var htCalendarUnk: UIColor = {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.lightGray
            } else {
                return UIColor.lightGray
            }
        }
    }()
    
    static var background: UIColor = {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 30 / 255, green: 40 / 255, blue: 50 / 255, alpha: 1.0)
            } else {
                return UIColor.white
            }
        }
    }()
    
    static var border: UIColor = {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.36, green: 0.73, blue: 0.74, alpha: 1.00)
            } else {
                return UIColor(red: 0.27, green: 0.42, blue: 0.78, alpha: 1.00)
            }
        }
    }()
    
    static var fade: UIColor = {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.5)
            } else {
                return UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.2)
            }
        }
    }()
}
