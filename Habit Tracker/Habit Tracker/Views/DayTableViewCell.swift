//
//  DayTableViewCell.swift
//  Habit Tracker
//
//  Created by Lambda_School_Loaner_214 on 11/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class DayTableViewCell: UITableViewCell {

    // MARK: - Properties
    var day: Day? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var habitName: UILabel!
    @IBOutlet private weak var habitDate: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    
    // MARK: - View Lifecycle
    override internal func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override internal func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    
    @IBAction private func buttonsTapped(_ sender: UIButton) {
        guard let day = day else { return }
        switch sender.titleLabel?.text {
        case "Yes":
            HabitController.shared.updateDayStatus(day: day, status: .yes)
        case "No":
            HabitController.shared.updateDayStatus(day: day, status: .no)
        case .none:
            break
        default:
            break
        }
        updateViews()
    }
    
    
    // MARK: - Private Methods
    private func updateViews() {
        guard let day = day else { return }
        habitName.text = day.habit?.title
        habitName.textColor = .htTextColor
        habitDate.text = day.date?.formatted()
        habitDate.textColor = .htTextColor
        let dayStatus = DayStatus(rawValue: day.status)
        switch dayStatus {
        case .no:
            noButton.backgroundColor = .systemBlue
            yesButton.backgroundColor = .htCalendarYes
        case .yes:
            noButton.backgroundColor = .htCalendarNo
            yesButton.backgroundColor = .systemBlue
        case .unset:
            yesButton.backgroundColor = .htCalendarYes
            yesButton.setTitleColor(.white, for: .normal)
            noButton.backgroundColor = .htCalendarNo
            noButton.setTitleColor(.white, for: .normal)
        case .none:
            break
        }
    }

    override internal func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateViews()
    }
}
