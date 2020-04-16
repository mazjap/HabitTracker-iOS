//
//  HabitTableViewCell.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 11/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class HabitTableViewCell: UITableViewCell {
    
    var habit: Habit? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet private weak var habitTitleLabel: UILabel!
    @IBOutlet private weak var habitDescLabel: UILabel!
    @IBOutlet private weak var habitTimeLabel: UILabel!
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
        self.updateViews()
    }
    
    override internal dynamic func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 77.5, left: 3, bottom: 77.5, right: 3))
        self.contentView.layer.cornerRadius = 13
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.border.cgColor
        addSubview(contentView)
    }
    
    override internal func dragStateDidChange(_ dragState: UITableViewCell.DragState) {
        updateViews()
    }
    
    private func updateViews() {
        backgroundColor = .background
        habitTitleLabel.textColor = .htText
        habitDescLabel.textColor = .htText
        habitTimeLabel.textColor = .htText
        
        if let habit = habit, habitTitleLabel != nil, habitDescLabel != nil, habitTimeLabel != nil {
            habitTitleLabel.text = habit.title
            habitDescLabel.text = habit.desc
            
            if let date = habit.notifyTime, habit.notify {
                habitTimeLabel.isHidden = false
                habitTimeLabel.text = dateFormatter.string(from: date)
            } else {
                habitTimeLabel.isHidden = true
            }
            
            let status = habit.getDay(with: Calendar.current.dateComponents([.day, .month, .year], from: Date()))?.status
            if status == DayStatus.yes.rawValue {
                habitTitleLabel.textColor = .htCalendarYes
            } else if status == DayStatus.no.rawValue {
                habitTitleLabel.textColor = .htCalendarNo
            }
        }
    }
    
    override internal func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateViews()
    }
}
