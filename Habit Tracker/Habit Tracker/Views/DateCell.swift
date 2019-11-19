//
//  DateCell.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 11/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import JTAppleCalendar
import UIKit

class DateCell: JTACDayCell {
    var day: Day?
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var selectedView: UIView!
    @IBOutlet weak var statusView: UIView!
}
