//
//  FMPSaveAdsViewController.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 25/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit

class SaveAdsViewController: MenuBaseViewController {
    private let dataSource = SaveAdsDatasource()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        dataSource.dataChange = { [weak self] in
            self?.tableView.reloadData()
        }
        navigationItem.rightBarButtonItems?.removeAll(where: {$0.title == "Settings"})
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = self.delete(rowAtindexPath: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = self.edit(rowAtindexPath: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [edit])
        return swipe
    }
    
    // MARK: - IBAction
    @IBAction func addButtonPressed(_ sender: Any) {
        super.addCTAPressed(sender)
    }
    
    // MARK: - UITableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        showAdOnAdViewController(with: indexPath)
    }
}

// MARK: - Service

private extension SaveAdsViewController {
    private func delete(rowAtindexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            guard let self = self else {return}
            if let cell = self.tableView.cellForRow(at: indexPath) as? AdUnitCustomCell {
                SavedAdsManager.sharedInstance.removeSavedAd(adUnit: cell.model!)
            }
        }
        
        return action
    }
    
    private func edit(rowAtindexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") {[weak self] (_, _, _) in
            guard let self = self else {return}
            if let cell = self.tableView.cellForRow(at: indexPath) as? AdUnitCustomCell {
                let adUnit = cell.model
                
                ClientRequestSettings.shared.willEditAdUnit()
                self.performSegue(withIdentifier: StoryboardsSegues.ShowNewAdUnitSegue.rawValue, sender: adUnit!)
            }
        }
        action.backgroundColor = .blue
        return action
    }
    
    private func showAdOnAdViewController(with indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AdUnitCustomCell {
            performSegue(withIdentifier: StoryboardsSegues.ShowAdVCSegue.rawValue, sender: cell.model)
        }
    }
}
