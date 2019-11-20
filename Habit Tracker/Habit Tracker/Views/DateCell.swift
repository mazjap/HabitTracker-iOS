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
    var state: CellState? {
        didSet {
            handleCellTextColor()
        }
    }
    var day: Day? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var selectedView: UIView!
    @IBOutlet private weak var statusView: UIView!
    
    func updateViews() {
        selectedView.isHidden = true
        statusView.backgroundColor = .darkGray
        statusView.layer.cornerRadius = 13
        selectedView.layer.cornerRadius = 13
        handleCellStatus()
    }
    
    func setTextColor(color: UIColor) {
        dateLabel.textColor = color
    }
    
    func toggleSelected() {
        selectedView.isHidden.toggle()
    }
    
    func setDate(date: String) {
        dateLabel.text = date
    }
    
    func handleCellStatus() {
        guard let day = day else {
            statusView.backgroundColor = .clear
            handleCellTextColor()
            return
        }
        dateLabel.textColor = .white
        switch DayStatus(rawValue: day.status) {
        case .yes:
            statusView.backgroundColor = UIColor.green
            
        case .no:
            statusView.backgroundColor = UIColor.red
        default:
            statusView.backgroundColor = .darkGray
        }
    }
    
    func handleCellTextColor() {
        guard let state = state else {
            setTextColor(color: .black)
            return
        }
        if state.dateBelongsTo == .thisMonth {
            setTextColor(color: .black)
        } else if day != nil && day?.status != -1 {
            setTextColor(color: .white)
        } else {
            setTextColor(color: .gray)
        }
    }
}
