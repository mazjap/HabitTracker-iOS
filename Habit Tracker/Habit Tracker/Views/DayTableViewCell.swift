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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IBActions
    @IBAction func buttonsTapped(_ sender: UIButton) {
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
        habitDate.text = day.date?.formatted()
        let dayStatus = DayStatus(rawValue: day.status)
        switch dayStatus {
        case .no:
            noButton.backgroundColor = .systemBlue
            yesButton.backgroundColor = UIColor.htCalendarYes
        case .yes:
            noButton.backgroundColor = UIColor.htCalendarNo
            yesButton.backgroundColor = .systemBlue
        case .unset:
            yesButton.backgroundColor = UIColor.htCalendarYes
            noButton.backgroundColor = UIColor.htCalendarNo
        case .none:
            break
        }
    }

}
