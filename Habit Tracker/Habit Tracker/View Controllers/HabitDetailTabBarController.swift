//
//  HabitDetailTabBarController.swift
//  Habit Tracker
//
//  Created by Lambda_School_Loaner_214 on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class HabitDetailTabBarController: UITabBarController {
    
    //MARK: - Properties
    var habit: Habit?
    
    //MARK: - IBOutlets
    @IBOutlet weak var myTabBar: UITabBar!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let controllers = tabBarController?.viewControllers else { return }
//        for VC in controllers {
//            if let vc = VC as? HabitHandlerProtocol {
//                vc.habit = self.habit
//            }
//        }
        myTabBar.delegate = self
        let detailVC = tabBarController?.viewControllers?[0] as? HabitDetailTabBarController
        if let vc = detailVC { vc.habit = self.habit }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let detailVC = tabBarController?.viewControllers?[0] as? HabitDetailTabBarController
        if let vc = detailVC { vc.habit = self.habit }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

//MARK: - Extensions
}
extension HabitDetailTabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
}
