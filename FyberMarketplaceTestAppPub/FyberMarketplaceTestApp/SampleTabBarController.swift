//
//  FMPSampleTabBarController.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 03/10/2021.
//  Copyright © 2021 Fyber. All rights reserved.
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
