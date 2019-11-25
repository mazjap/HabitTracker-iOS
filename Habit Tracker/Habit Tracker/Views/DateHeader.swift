//
//  DateHeader.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateHeader: JTACMonthReusableView {
    @IBOutlet private weak var monthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor.borderColor.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 6
    }
    
    func setMonthLabel(with text: String) {
        monthLabel.text = text
        monthLabel.textColor = .htTextColor
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.layer.borderColor = UIColor.borderColor.cgColor
        monthLabel.textColor = .htTextColor
    }
}
