//
//  BaseTableViewController.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 13/04/2022.
//  Copyright © 2022 Fyber. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustBackgroundColor()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func didBecomeActive(_ notification: Notification)  {
        adjustBackgroundColor()
    }
}
