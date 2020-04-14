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
    private let pickerData: [String] = {
        Array(1...365).map { String($0) }
    }()
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var goalDayPickerView: UIPickerView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var notifySwitch: UISwitch!
    @IBOutlet private weak var notifyTimeDatePicker: UIDatePicker!
    @IBOutlet private weak var notifyLabel: UILabel!
    @IBOutlet private weak var completionLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        let menuToggle = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2.fill"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.presentMenu))
        self.navigationItem.setRightBarButton(menuToggle, animated: true)
        setDescTextColor()
        goalDayPickerView.dataSource = self
        goalDayPickerView.delegate = self
        descriptionTextView.delegate = self
        titleTextField.delegate = self
        updateViews()
    }
    
    @IBAction private func saveTapped(_ sender: UIButton) {
        guard let title = titleTextField.text,
            let desc = descriptionTextView.text,
            !title.isEmpty, !desc.isEmpty else { return }
        if (title == "Dev" || title == "dev") && (desc == "Settings" || desc == "settings") {
            devSettings = true
            UserDefaults.standard.set(devSettings, forKey: "devSettings")
        }
        let days = goalDayPickerView.selectedRow(inComponent: 0)
        let notify = notifySwitch.isOn
        let date = notifyTimeDatePicker.date
        
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let dc = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: date)
        let newDc = DateComponents(year: dc.year, month: dc.month, day: dc.day, hour: dc.hour, minute: (((dc.minute ?? 0) / 15) * 15))
        guard let cal = calendar, let time = cal.date(from: newDc) else { return }
        
        if let habit = habit {
            HabitController.shared.update(habit: habit, title: title, desc: desc, goalDays: days, notify: notify, notifyTime: time)
        } else {
            self.habit = HabitController.shared.add(title: title, desc: desc, goalDays: days, notify: notify, notifyTime: time)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func switchChanged(_ sender: UISwitch) {
        guard let habit = habit else { return }
        HabitController.shared.updateHabitNotifications(habit: habit, notify: notifySwitch.isOn)
        updateViews()
    }
    
    
    // MARK: - Private Methods
    
    private func updateViews() {
        notifySwitch.layer.cornerRadius = 16
        notifySwitch.layer.borderWidth = 2
        saveButton.layer.cornerRadius = 8
        
        updateColors()
        
        setTextViewBorder(for: descriptionTextView)
        if let habit = habit {
            title = "\(habit.title ?? "")"
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            titleTextField.text = habit.title
            descriptionTextView.text = habit.desc
            goalDayPickerView.selectRow((Int(habit.goalDays)), inComponent: 0, animated: true)
            notifySwitch.isOn = habit.notify
            notifyTimeDatePicker.isHidden = !notifySwitch.isOn
            notifyTimeDatePicker.heightAnchor.constraint(equalToConstant: 75).isActive = true
            if let time = habit.notifyTime {
                notifyTimeDatePicker.date = time
            }
        } else {
            title = "Add New Habit"
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            goalDayPickerView.selectRow(20, inComponent: 0, animated: true)
            notifyTimeDatePicker.setDate(Date(), animated: false)
            
        }
    }
    
    private func updateColors() {
        view.backgroundColor = .backgroundColor
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.htTextColor]
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.htTextColor]
        navigationController?.navigationBar.tintColor = UIColor.htTextColor
        titleTextField.textColor = .htTextColor
        notifyLabel.textColor = .htTextColor
        completionLabel.textColor = .htTextColor
        
        notifyTimeDatePicker.setValue(UIColor.htTextColor, forKeyPath: "textColor")
        notifySwitch.layer.borderColor = UIColor.htTextColor.cgColor
        
        saveButton.backgroundColor = UIColor.htTextColor
        saveButton.setTitleColor(.white, for: .normal)
    }
    
    private func setDescTextColor() {
        if habit == nil {
            descriptionTextView.text = "Goal Description"
            descriptionTextView.textColor = .lightGray
        } else {
            descriptionTextView.textColor = .htTextColor
        }
    }
    
    private func setTextViewBorder(for textView: UITextView) {
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 0.75).cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc
    private func presentMenu() {
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
}

extension HabitDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.htTextColor])
    }
}

extension HabitDetailViewController: UITextViewDelegate, UITextFieldDelegate {
    
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .htTextColor
        }
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Goal Description"
            textView.textColor = .lightGray
        }
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = "Habit Title"
    }
}
