//
//  MenuBaseViewController.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 02/05/2022.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

class MenuBaseViewController: BaseTableViewController {
    private lazy var router: Router = RouterImpl()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        hideTabBarIfNeeded(segue: segue)
        router.route(with: segue, sender: sender)
    }

    private func hideTabBarIfNeeded(segue: UIStoryboardSegue) {
        if segue.identifier != StoryboardsSegues.ConsoleViewControllerSegues.rawValue {
            self.tabBarController?.tabBar.isHidden = true
        }
    }

    func addCTAPressed(_ sender: Any) {
        addButtonAction(sender, delegate: nil)
    }
}
