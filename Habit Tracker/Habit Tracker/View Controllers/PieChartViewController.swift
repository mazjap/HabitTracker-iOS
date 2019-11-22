//
//  PieChartViewController.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import PieCharts
import SideMenu
import UIKit

class PieChartViewController: UIViewController, HabitHandlerProtocol {
    
    var habit: Habit?
    @IBOutlet private weak var habitsPieChart: PieChart!
    @IBOutlet private weak var completeColorView: UIView!
    @IBOutlet private weak var incompleteColorView: UIView!
    @IBOutlet private weak var unknownColorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    func updateViews() {
        habitsPieChart.clear()
        
        completeColorView.backgroundColor = .htCalendarYes
        incompleteColorView.backgroundColor = .htCalendarNo
        unknownColorView.backgroundColor = .htCalendarUnk
        
        guard let habit = habit, let days = habit.days?.allObjects as? [Day] else { return }
        let total = Double(habit.days?.allObjects.count ?? 1)
        var complete = 0.0, incomplete = 0.0, unknown = 0.0
        for day in days {
            switch day.status {
            case 1:
                complete += 1
            case -1:
                incomplete += 1
            default:
                unknown += 1
            }
        }
        
        let completeValue = PieSliceModel(value: complete / total, color: .htCalendarYes)
        let incompleteValue = PieSliceModel(value: incomplete / total, color: .htCalendarNo)
        let unchecked = PieSliceModel(value: unknown / total, color: .htCalendarUnk)
        
        habitsPieChart.models = [completeValue, incompleteValue, unchecked]
        
        let textLayerSettings = PieLineTextLayerSettings()
        textLayerSettings.label.font = UIFont.boldSystemFont(ofSize: 16)
        textLayerSettings.label.textColor = UIColor.borderColor

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            formatter.string(from: slice.data.percentage * 100 as NSNumber).map { "\($0)%" } ?? ""
        }

        let textLayer = PieLineTextLayer()
        textLayer.settings = textLayerSettings
        
        habitsPieChart.layers = [textLayer]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        PieLineTextLayerSettings().label.textColor = UIColor.borderColor
//        textLayer.settings = textLayerSettings
    }
}
