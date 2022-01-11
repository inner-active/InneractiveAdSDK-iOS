//
//  FMPMarketplaceViewController.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 21/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import UIKit

class SampleAdsViewController: UITableViewController {
    private let tableViewDataSource = MenuTableViewDataSource()

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        adjustForDarkMode()
        tableView.dataSource = tableViewDataSource

        navigationItem.leftBarButtonItems = nil
        navigationItem.rightBarButtonItems?.removeAll(where: {$0.title == "Settings"})
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier != StoryboardsSegues.ConsoleViewControllerSegues.rawValue else { return }
        
        self.tabBarController?.tabBar.isHidden = true
        if segue.identifier == StoryboardsSegues.ShowAdVCSegue.rawValue {
            let cell = sender as! AdUnitCustomCell
            let controller = segue.destination as! AdViewController
            controller.setup(with: MarketplaceSDK(presentingViewController: controller), adType: cell.model!.format, title: cell.textLabel!.text!)
        }
    }
}

//MARK: - UITableview Delegate

extension SampleAdsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AdUnitCustomCell

        UISelectionFeedbackGenerator().selectionChanged()
        ClientRequestSettings.shared.updateClientRequest(with: cell.model!)
        performSegue(withIdentifier: StoryboardsSegues.ShowAdVCSegue.rawValue, sender: cell)
    }
}
