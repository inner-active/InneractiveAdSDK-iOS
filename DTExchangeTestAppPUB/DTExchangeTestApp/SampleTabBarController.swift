//
//  FMPSampleTabBarController.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 03/10/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit

class SampleTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
