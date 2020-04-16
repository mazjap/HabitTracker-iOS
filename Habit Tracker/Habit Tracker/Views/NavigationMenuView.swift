//
//  NavigationMenuView.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 4/15/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class NavigationMenuView: UITableView {
    var isToggled = false
    
    func setUp() {
        backgroundColor = .background
    }
    
    func toggleBool() {
        isToggled.toggle()
    }
}
