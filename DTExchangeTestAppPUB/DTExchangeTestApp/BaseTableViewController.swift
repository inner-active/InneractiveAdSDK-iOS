//
//  BaseTableViewController.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 13/04/2022.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustBackgroundColor()
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func didBecomeActive(_ notification: Notification) {
        adjustBackgroundColor()
    }
}

// MARK: - UITableView Delegate

extension BaseTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
