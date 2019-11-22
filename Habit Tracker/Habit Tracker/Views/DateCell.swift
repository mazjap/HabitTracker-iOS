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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateViews()
    }
    
    func updateViews() {
        selectedView.isHidden = true
        statusView.layer.cornerRadius = 13
        selectedView.layer.cornerRadius = 13
        selectedView.layer.borderWidth = 2
        selectedView.layer.borderColor = UIColor.blue.cgColor
        statusView.layer.borderWidth = 2
        //statusView.layer.borderColor = UIColor.borderColor.cgColor
        handleCellStatus()
    }
    
    // MARK: - Public Methods
    func setTextColor(color: UIColor) {
        dateLabel.textColor = color
    }
    
    func setNotSelected() {
        selectedView.isHidden = true
    }
    
    func setSelected() {
        selectedView.isHidden = false
    }
    
    func setDate(date: String) {
        dateLabel.text = date
    }
    
    func handleCellStatus() {
        guard let day = day else {
            statusView.backgroundColor = .htBackground
            handleCellTextColor()
            return
        }
        dateLabel.textColor = .white
        switch DayStatus(rawValue: day.status) {
        case .yes:
            statusView.backgroundColor = .htCalendarYes
            
        case .no:
            statusView.backgroundColor = .htCalendarNo
        default:
            statusView.backgroundColor = .htCalendarUnk
        }
    }
    
    // MARK: - Private Methods
    private func handleCellTextColor() {
        guard let state = state else {
            setTextColor(color: .black)
            return
        }
        if state.dateBelongsTo == .thisMonth {
            setTextColor(color: .white)
        } else {
            setTextColor(color: .gray)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        statusView.layer.borderColor = UIColor.borderColor.cgColor
    }
}
