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
    @IBOutlet private weak var completeLabel: UILabel!
    @IBOutlet private weak var incompleteLabel: UILabel!
    @IBOutlet private weak var unknownLabel: UILabel!
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    private func updateViews() {
        habitsPieChart.clear()
        title = "Pie Chart"
        
        updateColors()
        
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
        
        var models = [PieSliceModel]()
        
        if complete != 0.0 {
            models.append(PieSliceModel(value: complete / total, color: .htCalendarYes))
        } else if incomplete != 0.0 {
            models.append(PieSliceModel(value: incomplete / total, color: .htCalendarNo))
        } else if unknown != 0.0 {
            models.append(PieSliceModel(value: unknown / total, color: .htCalendarUnk))
        }
        
        habitsPieChart.models = models
        
        let textLayerSettings = PieLineTextLayerSettings()
        textLayerSettings.label.font = UIFont.boldSystemFont(ofSize: 16)
        textLayerSettings.label.textColor = UIColor.border

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            formatter.string(from: slice.data.percentage * 100 as NSNumber).map { "\($0)%" } ?? ""
        }

        let textLayer = PieLineTextLayer()
        textLayer.settings = textLayerSettings
        habitsPieChart.layers = [textLayer]
    }
    
    func updateColors() {
        view.backgroundColor = .background
        completeColorView.backgroundColor = .htCalendarYes
        incompleteColorView.backgroundColor = .htCalendarNo
        unknownColorView.backgroundColor = .htCalendarUnk
        habitsPieChart.backgroundColor = .background
        
        completeLabel.textColor = .htText
        incompleteLabel.textColor = .htText
        unknownLabel.textColor = .htText
    }
    
    override internal func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        PieLineTextLayerSettings().label.textColor = UIColor.htText
//        PieLineTextLayerSettings().lineColor = UIColor.borderColor Not a set, only get
//        textLayer.settings = textLayerSettingss
    }
}
