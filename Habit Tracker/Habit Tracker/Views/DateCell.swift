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
    
    // MARK: - Properties
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
    
    // MARK: - IBOutlets
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var selectedView: UIView!
    @IBOutlet private weak var statusView: UIView!
    
    // MARK: - Private Methods
    private func updateViews() {
        selectedView.isHidden = true
        statusView.backgroundColor = .darkGray
        statusView.layer.cornerRadius = 13
        selectedView.layer.cornerRadius = 13
        handleCellStatus()
    }
    
    // MARK: - Public Methods
    func setTextColor(color: UIColor) {
        dateLabel.textColor = color
    }
    
    func toggleSelected() {
        selectedView.isHidden.toggle()
    }
    
    func setDate(date: String) {
        dateLabel.text = date
    }
    
    // MARK: - Private Methods
    private func handleCellStatus() {
        guard let day = day else {
            statusView.backgroundColor = .clear
            handleCellTextColor()
            return
        }
        dateLabel.textColor = .white
        switch DayStatus(rawValue: day.status) {
        case .yes:
            statusView.backgroundColor = UIColor.htCalendarYes
            
        case .no:
            statusView.backgroundColor = UIColor.htCalendarNo
        default:
            statusView.backgroundColor = UIColor.htCalendarUnk
        }
    }
    
    private func handleCellTextColor() {
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
