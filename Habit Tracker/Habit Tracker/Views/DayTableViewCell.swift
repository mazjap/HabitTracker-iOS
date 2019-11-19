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

    //MARK: - Properties
    var day: Day? {
        didSet{
            updateViews()
        }
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var habitName: UILabel!
    @IBOutlet weak var habitDate: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    
    //MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - IBActions
    
    @IBAction func buttonsTapped(_ sender: UIButton) {
        guard let day = day else { return }
        switch sender.titleLabel?.text {
        case "Yes":
            day.status = DayStatus.yes.rawValue
        case "No":
            day.status = DayStatus.no.rawValue
        case .none:
            break
        case .some(_):
            break
        }
        updateViews()
    }
    
    
    //MARK: - Private Methods
    private func updateViews() {
        
        guard let day = day else { return }
        habitName.text = day.habit?.title
        habitDate.text = day.date?.formatted()
        let dayStatus = DayStatus(rawValue: day.status)
        switch dayStatus {
        case .no:
            noButton.backgroundColor = .systemBlue
            yesButton.backgroundColor = .clear
        case .yes:
            noButton.backgroundColor = .clear
            yesButton.backgroundColor = .systemBlue
        case .unset:
            yesButton.backgroundColor = .clear
            noButton.backgroundColor = .clear
        case .none:
            break
        }
    }

}