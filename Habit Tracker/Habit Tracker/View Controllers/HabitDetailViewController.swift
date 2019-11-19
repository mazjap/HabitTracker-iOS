//
//  HabitDetailViewController.swift
//  Habit Tracker
//
//  Created by Lambda_School_Loaner_214 on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class HabitDetailViewController: UIViewController, HabitHandlerProtocol {
    
    var habit: Habit?
    let pickerData: [String] = {
        return Array(21...365).map { String($0)}
    }()
    
    @IBOutlet weak var habitNameTF: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var descriptionTV: UITextView!
    
    
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
        if let habit = habit {
            HabitController.shared.update(habit: habit, title: title, desc: desc, goalDays: days)
        } else {
            self.habit = HabitController.shared.add(title: title, desc: desc, goalDays: days)
            HabitController.shared.addDay(habit: self.habit!)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        if let habit = habit {
            title = habit.title
            habitNameTF.text = habit.title
            descriptionTV.text = habit.desc
            pickerView.selectedRow(inComponent: (Int(habit.goalDays - 21)))
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
