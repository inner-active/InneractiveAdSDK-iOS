//
//  FMPSaveAdsViewController.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 25/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import UIKit
 
class SaveAdsViewController: UITableViewController {
    private let dataSource = SaveAdsDatasource()

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustForDarkMode()
        
        tableView.dataSource = dataSource
        dataSource.dataChange = { [weak self] in
            self?.tableView.reloadData()
        }
    
        navigationItem.rightBarButtonItems?.removeAll(where: {$0.title == "Settings"})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AdUnitCustomCell
        
        UISelectionFeedbackGenerator().selectionChanged()
        ClientRequestSettings.shared.updateClientRequest(with: cell.model!)
        performSegue(withIdentifier: StoryboardsSegues.ShowAdVCSegue.rawValue, sender: cell.model)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier != StoryboardsSegues.ConsoleViewControllerSegues.rawValue else { return }
        
        self.tabBarController?.tabBar.isHidden = true
        if segue.identifier == StoryboardsSegues.ShowAdVCSegue.rawValue  {
            let model = sender as! AdUnit
            let controller = segue.destination as! AdViewController
            controller.setup(with: MarketplaceSDK(presentingViewController: controller), adType: model.format, title: model.name)
            ClientRequestSettings.shared.removeUserDefaultsIfNeeded()
        }
    }
}
