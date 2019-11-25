//
//  SideMenuTableViewController.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 11/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController, HabitHandlerProtocol {
    
    var habit: Habit?
    
    @IBOutlet private weak var calendarLabel: UILabel!
    @IBOutlet private weak var pieChartLabel: UILabel!
    @IBOutlet private weak var unmarkedDaysLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateColors()
    }
    
    private func updateColors() {
        calendarLabel.textColor = .htTextColor
        pieChartLabel.textColor = .htTextColor
        unmarkedDaysLabel.textColor = .htTextColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CalendarShowSegue" {
            guard let detailVC = segue.destination as? CalenderViewController else { return }
            detailVC.habit = habit
        } else if segue.identifier == "PieChartShowSegue" {
            guard let detailVC = segue.destination as? PieChartViewController else { return }
            detailVC.habit = habit
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
}
