//
//  SettingsDatasource.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 28/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

struct NewAdUnitSection {
    let title: String
    let model: SampleSetting
}

class NewAdUnitDataSource:NSObject {
    private var models: [[NewAdUnitSection]]!
    private var newAdUnitType:SampleAdType? = .Banner
    
    
    override init() {
        super.init()
        configureCells()
    }
    
    //MARK: - Service
    private func configureCells() {
        models = [
            [NewAdUnitSection(title: "Ad Format", model: .NewAdFormat)],
            [NewAdUnitSection(title: "Mock", model: .NewMockName)]
        ]
    }
    
    private func getMultiValueCellOptions(for setting: SampleSetting) -> [String] {
        switch setting {
        case .NewAdFormat: return [SampleAdType.Banner.rawValue, SampleAdType.Rectangle.rawValue, SampleAdType.Interstitial.rawValue, SampleAdType.Rewarded.rawValue]
        default: return [""]
        }
    }
    
    func createNewAdUnit() -> AdUnit? {
        var adUnit:AdUnit? = nil
        
        if  let mockName = ClientRequestSettings.shared.getValue(of: .NewMockName), mockName.count > 0 {
            let unitType = SampleAdType.init(rawValue: ClientRequestSettings.shared.getValue(of: .NewAdFormat)!)
            adUnit = AdUnit(id: mockName, mockName, unitType!, .Mock)
            SavedAdsManager.sharedInstance.addSavedAd(adUnit: adUnit!)
        }
        return adUnit
    }
}

//MARK: - UITableViewDataSource
extension NewAdUnitDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row].model
        
        switch model {
        case .NewAdFormat:
            return MultiValuesCustomCell.configure(with: model, table: tableView, indexPath: indexPath, options: getMultiValueCellOptions(for: model), delegate: ClientRequestSettings.shared)
        case .NewMockName:
            return TextFieldCustomCell.configure(with: model, table: tableView, indexPath: indexPath, delegate: ClientRequestSettings.shared)
        default:return UITableViewCell()
        }
    }
}
