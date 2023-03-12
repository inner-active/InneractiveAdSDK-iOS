//
//  NewAdUnitDataSource.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 28/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

typealias UserInput = (mock: String?, spot: String, portal: String?)

struct NewAdUnitSection {
    let title: String
    let model: SampleSettingsEnum
}

enum InputError: Error {
    case spotIdMissing
    case portalOrMockMissing
}

extension InputError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .spotIdMissing:
            return NSLocalizedString("Please fill spot ID field.", comment: "")
        case .portalOrMockMissing:
            return NSLocalizedString("Please fill at least portal or mock fields.", comment: "")
        }
    }
}

class NewAdUnitDataSource: NSObject {
    private var models: [[NewAdUnitSection]]!
    private var newAdUnitType: SampleAdTypeEnum? = .banner
    
    override init() {
        super.init()
        configureCells()
    }
    
    // MARK: - Service
    
    private func configureCells() {
        models = [
            [NewAdUnitSection(title: "Ad Format", model: .adFormat)],
            [NewAdUnitSection(title: "Spot Id", model: .spotIdNew)],
            [NewAdUnitSection(title: "Portal", model: .portalNew)],
            [NewAdUnitSection(title: "Mock", model: .mockName)]]
    }
    
    private func getMultiValueCellOptions(for setting: SampleSettingsEnum) -> [String] {
        switch setting {
        case .adFormat:
            return [
                SampleAdTypeEnum.banner.rawValue,
                SampleAdTypeEnum.rectangle.rawValue,
                SampleAdTypeEnum.interstitial.rawValue,
                SampleAdTypeEnum.rewarded.rawValue]
        default: return [""]
        }
    }
    
    func createNewAdUnit() -> Result<AdUnit, InputError> {
        var adUnit: AdUnit
        let inputResult = validateUserInputs()
        
        do {
            let userInput = try inputResult.get()
            let unitType = SampleAdTypeEnum(rawValue: ClientRequestSettings.shared.getValue(of: .adFormat)!)
            adUnit = AdUnit(id: userInput.mock,
                            name: userInput.mock,
                            format: unitType!,
                            source: .mock,
                            spotid: userInput.spot,
                            portal: userInput.portal)
            
            SavedAdsManager.sharedInstance.addSavedAd(adUnit: adUnit)
        } catch {
            // swiftlint:disable force_cast
            return .failure(error as! InputError)
            // swiftlint:enable force_cast
        }
        
        return .success(adUnit)
    }
    
    private func validateUserInputs() -> Result<UserInput, InputError> {
        guard let spotId = ClientRequestSettings.shared.getValue(of: .spotIdNew),
              !spotId.isEmpty else { return .failure(.spotIdMissing) }
        
        let portal = ClientRequestSettings.shared.getValue(of: .portalNew)
        let mockName = ClientRequestSettings.shared.getValue(of: .mockName)
        
        guard portal?.isEmpty == false || mockName?.isEmpty == false
        else { return .failure(.portalOrMockMissing) }
       
        return .success(UserInput(mock: mockName, spot: spotId, portal: portal))
    }
}

// MARK: - UITableViewDataSource

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
        case .adFormat:
            return MultiValuesCustomCell.configure(
                with: model,
                table: tableView,
                indexPath: indexPath,
                options: getMultiValueCellOptions(for: model),
                delegate: ClientRequestSettings.shared)
        case .spotIdNew, .portalNew, .mockName:
            return TextFieldCustomCell.configure(with: model,
                                                 table: tableView,
                                                 indexPath: indexPath,
                                                 delegate: ClientRequestSettings.shared)
        default: return UITableViewCell()
        }
    }
}
