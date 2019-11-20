//
//  PieChartViewController.swift
//  Habit Tracker
//
//  Created by Jordan Christensen on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import PieCharts

class PieChartViewController: UIViewController, HabitHandlerProtocol {
    
    var habit: Habit?
    @IBOutlet weak var habitsPieChart: PieChart!
    @IBOutlet weak var completeColorView: UIView!
    @IBOutlet weak var incompleteColorView: UIView!
    @IBOutlet weak var unknownColorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        completeColorView.backgroundColor = .green
        incompleteColorView.backgroundColor = .red
        unknownColorView.backgroundColor = .darkGray
        
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
        
        let completeValue = PieSliceModel(value: 0.7 /* complete/total */, color: UIColor.green)
        let incompleteValue = PieSliceModel(value: 0.05 /* incomplete/total */, color: UIColor.darkGray)
        let unchecked = PieSliceModel(value: 0.25 /* unknown/total */, color: UIColor.red)
        
        habitsPieChart.models = [completeValue, incompleteValue, unchecked]
        
        let textLayerSettings = PieLineTextLayerSettings()
        textLayerSettings.label.font = UIFont.boldSystemFont(ofSize: 16)

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }

        let textLayer = PieLineTextLayer()
//        textLayer.animator = AlphaPieViewLayerAnimator()
        textLayer.settings = textLayerSettings
        
        habitsPieChart.layers = [textLayer]
    }
}
