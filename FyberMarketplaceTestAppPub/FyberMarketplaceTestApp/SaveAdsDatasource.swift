//
//  FMPSaveAdsDatasource.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 26/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

class SaveAdsDatasource:NSObject {
    private var models: [AdUnit] = []
    var dataChange:(() -> Void)?
    
    override init() {
        super.init()
        SavedAdsManager.sharedInstance.delegate = self
        models = SavedAdsManager.sharedInstance.savedAds
    }
    
    //MARK: - Service
    private func fetchModels() {
        models = SavedAdsManager.sharedInstance.savedAds
        DispatchQueue.main.async {
            guard let dataChange = self.dataChange else { return }
            dataChange()
        }
    }
}

//MARK: - UITableViewDataSource
extension SaveAdsDatasource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: AdUnitCustomCell.identifier, for: indexPath) as! AdUnitCustomCell
        cell.configure(with: model)
        cell.detailTextLabel?.text = model.format.rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       guard editingStyle == .delete else {
           return
       }
       let cell = tableView.cellForRow(at: indexPath) as! AdUnitCustomCell
       SavedAdsManager.sharedInstance.removeSavedAd(adUnit: cell.model!)
   }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Save Ads"
    }
}

//MARK: - SavedAdsManagerDelegate
extension SaveAdsDatasource: SavedAdsManagerDelegate {
    func AdSuccefullySaved() {
        fetchModels()
    }
    
    func AdSuccessfullyRemoved() {
        fetchModels()
    }
}
