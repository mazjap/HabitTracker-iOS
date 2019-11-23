//
//  CalenderViewController.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 11/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import JTAppleCalendar
import SideMenu
import UIKit

class CalenderViewController: UIViewController, HabitHandlerProtocol {
    
    var habit: Habit?
    let formatter = DateFormatter()
    var selectedCell: DateCell?

    @IBOutlet private weak var habitMonthView: JTACMonthView!
    @IBOutlet private weak var completedLabel: UILabel!
    @IBOutlet private weak var isCompletedSwitch: UISwitch!
    @IBOutlet private weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        habitMonthView.layer.borderColor = UIColor.borderColor.cgColor
        habitMonthView.layer.borderWidth = 2
        habitMonthView.layer.cornerRadius = 6
        
        habitMonthView.scrollingMode = .stopAtEachCalendarFrame
        habitMonthView.scrollDirection = .horizontal
        habitMonthView.showsHorizontalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    func updateViews() {
        habitMonthView.reloadData()
        completedLabel.isHidden = true
        isCompletedSwitch.isHidden = true
        saveButton.isHidden = true
        title = "Calender"
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        habitMonthView.layer.borderColor = UIColor.borderColor.cgColor
    }
    
    @IBAction func toggleDayStatus(_ sender: UISwitch) {
        
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let cell = selectedCell, let day = cell.day else { return }
        HabitController.shared.updateDayStatus(day: day, status: isCompletedSwitch?.isOn == true ? DayStatus.yes : DayStatus.no)
        updateViews()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalenderViewController: JTACMonthViewDataSource, JTACMonthViewDelegate {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        let currentDate = Date()
        let difference = TimeInterval(exactly: 15552000)!
        let startDate = habit?.startDate ?? currentDate - difference
        let endDate = currentDate + difference
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCell else { return JTACDayCell() }
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        let time = Calendar.current.dateComponents([.day, .month, .year], from: cellState.date)
        if let habit = habit {
            cell.day = habit.getDay(with: time)
        }
        cell.state = cellState
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.setNotSelected()
        cell.setDate(date: cellState.text)
        handleCellSelected(cell: cell, cellState: cellState)
        cell.handleCellStatus()
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.setSelected()
            guard let day = cell.day, let date = day.date else {
                completedLabel.isHidden = true
                isCompletedSwitch.isHidden = true
                saveButton.isHidden = true
                selectedCell = nil
                return
            }
            selectedCell = cell
            formatter.dateFormat = "MM/dd/yyyy"
            completedLabel.isHidden = false
            completedLabel.text = "\(formatter.string(from: date)): Was \(habit?.title ?? "habit") completed?"
            isCompletedSwitch.isHidden = false
            isCompletedSwitch.isOn = day.status == 1 ? true : false
            saveButton.isHidden = false
        } else {
            cell.setNotSelected()
            selectedCell = nil
        }
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        formatter.dateFormat = "MMMM"
        
        guard let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader",
                                                                            for: indexPath) as? DateHeader else { return JTACMonthReusableView() }
        header.setMonthLabel(with: formatter.string(from: range.start))
        return header
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
}
