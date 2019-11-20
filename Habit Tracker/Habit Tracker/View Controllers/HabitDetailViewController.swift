//
//  HabitDetailViewController.swift
//  Habit Tracker
//
//  Created by Lambda_School_Loaner_214 on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class HabitDetailViewController: UIViewController, HabitHandlerProtocol {
    
    var habit: Habit?
    let pickerData: [String] = {
        Array(21...365).map { String($0) }
    }()
    
    @IBOutlet private weak var habitNameTF: UITextField!
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var descriptionTV: UITextField!
    @IBOutlet private weak var notifySwitch: UISwitch!
    @IBOutlet private weak var notifyTime: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = habitNameTF.text, !title.isEmpty,
            let desc = descriptionTV.text, !desc.isEmpty
            else { return }
        let days = pickerView.selectedRow(inComponent: 0) + 21
        let notify = notifySwitch.isOn
        let time = notifyTime.date
        if let habit = habit {
            HabitController.shared.update(habit: habit, title: title, desc: desc, goalDays: days, notify: notify, notifyTime: time)
        } else {
            self.habit = HabitController.shared.add(title: title, desc: desc, goalDays: days, notify: notify, notifyTime: time)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        
        updateViews()
    }
    
    
    // MARK: - Private Methods
    
    private func updateViews() {
        if let habit = habit {
            title = "Editing: \(habit.title ?? "")"
            habitNameTF.text = habit.title
            descriptionTV.text = habit.desc
            pickerView.selectedRow(inComponent: (Int(habit.goalDays - 21)))
            notifySwitch.isOn = habit.notify
            notifyTime.isHidden = !habit.notify
            if let time = habit.notifyTime {
                notifyTime.date = time
            }
        }
        title = "Add New Habbit"
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

extension HabitDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateViews()
    }
}
