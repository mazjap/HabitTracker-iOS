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
    let options = [(name: "Calendar", segue: "CalendarShowSegue"),
                   (name: "Pie Chart", segue: "PieChartShowSegue"),
                   (name: "Unmarked Days", segue: "UnmarkedDaysShowSegue")]
    private var fadeView = UIView()
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var goalDayPickerView: UIPickerView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var notifySwitch: UISwitch!
    @IBOutlet private weak var notifyTimeDatePicker: UIDatePicker!
    @IBOutlet private weak var notifyLabel: UILabel!
    @IBOutlet private weak var completionLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var navView: NavigationMenuView!
    
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        let menuToggle = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.toggleMenu))
        self.navigationItem.setRightBarButton(menuToggle, animated: true)
        setDescTextColor()
        goalDayPickerView.dataSource = self
        goalDayPickerView.delegate = self
        descriptionTextView.delegate = self
        titleTextField.delegate = self
        navView.delegate = self
        navView.dataSource = self
        navView.setUp()
        view.addSubview(fadeView)
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = navView.indexPathForSelectedRow {
            navView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction private func saveTapped(_ sender: UIButton) {
        guard let title = titleTextField.text,
            let desc = descriptionTextView.text,
            !title.isEmpty, !desc.isEmpty else { return }
        if title.lowercased() == "dev" && desc.lowercased() == "settings" {
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
        
        view.bringSubviewToFront(navView)
        fadeView.frame = view.frame
        fadeView.isHidden = true
        navView.tableFooterView = UIView()
        
        updateColors()
        
        setTextViewBorder(for: descriptionTextView)
        if let habit = habit {
            title = habit.title ?? ""
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
        view.backgroundColor = .background
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.htText]
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.htText]
        navigationController?.navigationBar.tintColor = UIColor.htText
        titleTextField.textColor = .htText
        titleTextField.backgroundColor = .background
        descriptionTextView.backgroundColor = .background
        notifyLabel.textColor = .htText
        completionLabel.textColor = .htText
        
        notifyTimeDatePicker.setValue(UIColor.htText, forKeyPath: "textColor")
        notifySwitch.layer.borderColor = UIColor.htText.cgColor
        
        saveButton.backgroundColor = UIColor.htText
        saveButton.setTitleColor(.white, for: .normal)
    }
    
    private func setDescTextColor() {
        if habit == nil {
            descriptionTextView.text = "Goal Description"
            descriptionTextView.textColor = .lightGray
        } else {
            descriptionTextView.textColor = .htText
        }
    }
    
    private func setTextViewBorder(for textView: UITextView) {
        textView.layer.borderWidth = 0.75
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5).cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc
    private func toggleMenu() {
        if !navView.isToggled {
            fadeView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.fadeView.backgroundColor = .fade
                self.navView.transform = CGAffineTransform(translationX: -self.navView.frame.width, y: 0)
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.fadeView.backgroundColor = .clear
                self.navView.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.fadeView.isHidden = true
            })
        }
        navView.toggleBool()
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard var vc = segue.destination as? HabitHandlerProtocol else { return }
            vc.habit = habit
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
        
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.htText])
    }
}

extension HabitDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NavTableViewCell", for: indexPath)
        
        cell.textLabel?.text = options[indexPath.row].name
        cell.textLabel?.textColor = .htText
        cell.backgroundColor = .background
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: options[indexPath.row].segue, sender: self)
        toggleMenu()
    }
}

extension HabitDetailViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .htText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Goal Description"
            textView.textColor = .lightGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = "Habit Title"
    }
}
