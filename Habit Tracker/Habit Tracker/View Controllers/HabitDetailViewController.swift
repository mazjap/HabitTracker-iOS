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
    @IBOutlet private weak var descriptionTV: UITextView!
    @IBOutlet private weak var notifySwitch: UISwitch!
    @IBOutlet private weak var notifyTime: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuToggle = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2.fill"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.presentMenu))
        self.navigationItem.setRightBarButton(menuToggle, animated: true)
        setDescTextColor()
        pickerView.dataSource = self
        pickerView.delegate = self
        descriptionTV.delegate = self
        habitNameTF.delegate = self
        updateViews()
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
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
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        guard let habit = habit else { return }
        HabitController.shared.updateHabitNotifications(habit: habit, notify: notifySwitch.isOn)
        updateViews()
    }
    
    
    // MARK: - Private Methods
    
    private func updateViews() {
        setTextViewBorder(for: descriptionTV)
        if let habit = habit {
            title = "\(habit.title ?? "")"
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            habitNameTF.text = habit.title
            descriptionTV.text = habit.desc
            pickerView.selectRow((Int(habit.goalDays - 21)), inComponent: 0, animated: true)
            notifySwitch.isOn = habit.notify
            notifyTime.isHidden = !notifySwitch.isOn
            if let time = habit.notifyTime {
                notifyTime.date = time
            }
        } else {
            title = "Add New Habit"
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    private func setDescTextColor() {
        if habit == nil {
            descriptionTV.text = "Other details"
            descriptionTV.textColor = .lightGray
        }
    }
    
    private func setTextViewBorder(for textView: UITextView) {
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
    }
    
    @objc
    func presentMenu() {
        performSegue(withIdentifier: "SideMenuModalSegue", sender: self)
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SideMenuModalSegue" {
            guard let vc = storyboard?.instantiateViewController(identifier: "SideMenuTableView") as? SideMenuTableViewController,
                let navVC = segue.destination as? UINavigationController else { return }
            
            navVC.pushViewController(vc, animated: true)
            vc.habit = habit
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
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
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        updateViews()
//    }
}

extension HabitDetailViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .borderColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Other details"
            textView.textColor = .lightGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
