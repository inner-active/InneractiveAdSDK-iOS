//
//  SettingsDatasource.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 28/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

typealias UserInput = (mock: String, spot: String, portal: String)

struct NewAdUnitSection {
    let title: String
    let model: SampleSettingsEnum
}

class NewAdUnitDataSource:NSObject {
    private var models: [[NewAdUnitSection]]!
    private var newAdUnitType:SampleAdTypeEnum? = .Banner
    
    override init() {
        super.init()
        configureCells()
    }
    
    //MARK: - Service
    private func configureCells() {
        models = [
            [NewAdUnitSection(title: "Ad Format", model: .AdFormat)],
            [NewAdUnitSection(title: "Spot Id", model: .SpotIdNew)],
            [NewAdUnitSection(title: "Portal", model: .PortalNew)],
            [NewAdUnitSection(title: "Mock", model: .MockName)]]
    }
    
    private func getMultiValueCellOptions(for setting: SampleSettingsEnum) -> [String] {
        switch setting {
        case .AdFormat: return [SampleAdTypeEnum.Banner.rawValue, SampleAdTypeEnum.Rectangle.rawValue, SampleAdTypeEnum.Interstitial.rawValue, SampleAdTypeEnum.Rewarded.rawValue]
        default: return [""]
        }
    }
    
    func createNewAdUnit() -> AdUnit? {
        var adUnit:AdUnit? = nil
        
        if let userInput = validateUserInputs() {
            let unitType = SampleAdTypeEnum(rawValue: ClientRequestSettings.shared.getValue(of: .AdFormat)!)
            adUnit = AdUnit(id: userInput.mock,
                            name: userInput.mock,
                            format: unitType!,
                            source: .Mock,
                            spotid: userInput.spot,
                            portal: userInput.portal)
            
            SavedAdsManager.sharedInstance.addSavedAd(adUnit: adUnit!)
        }
        return adUnit
    }
    
    private func validateUserInputs() -> UserInput? {
        if let spotId = ClientRequestSettings.shared.getValue(of: .SpotIdNew), spotId.count > 0,
           let portal = ClientRequestSettings.shared.getValue(of: .PortalNew), portal.count > 0,
           let mockName = ClientRequestSettings.shared.getValue(of: .MockName), mockName.count > 0 {
            return UserInput(mock: mockName, spot: spotId, portal: portal)
        }
        return nil
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
        case .AdFormat:
            return MultiValuesCustomCell.configure(with: model, table: tableView, indexPath: indexPath, options: getMultiValueCellOptions(for: model), delegate:  ClientRequestSettings.shared)
        case .SpotIdNew, .PortalNew, .MockName:
            return TextFieldCustomCell.configure(with: model, table: tableView, indexPath: indexPath, delegate: ClientRequestSettings.shared)
        default:return UITableViewCell()
        }
    }
}

