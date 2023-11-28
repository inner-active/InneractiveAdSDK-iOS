//
//  SaveAdsManager.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 25/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

protocol SavedAdsManagerDelegate: AnyObject {
    func AdSuccefullySaved()
    func AdSuccessfullyRemoved()
}

final class SavedAdsManager {
    static let sharedInstance = SavedAdsManager()
    private let serialQueue = DispatchQueue(label: "save.ad.manager.queue")
    private(set) var savedAds: [AdUnit]
    private let userDefaults: UserDefaults
    weak var delegate: SavedAdsManagerDelegate!
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        savedAds = userDefaults.savedAds
    }
    
    func addSavedAd(adUnit: AdUnit) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            self.savedAds.removeAll(where: { adUnit == $0 }) // avoid duplicate
            self.savedAds.insert(adUnit, at: 0)
            self.userDefaults.savedAds = self.savedAds
            DispatchQueue.main.async {
                self.delegate.AdSuccefullySaved()
            }
        }
    }
    
    func removeSavedAd(adUnit: AdUnit) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            self.savedAds.removeAll(where: { adUnit == $0 })
            self.userDefaults.savedAds = self.savedAds
            DispatchQueue.main.async {
                self.delegate.AdSuccessfullyRemoved()
            }
        }
    }
}

// MARK: - UserDefaults
private extension UserDefaults {
    static let savedAdsKey = "FMPSDKSavedAdsKey"
    var savedAds: [AdUnit] {
        get {
            var defaultValue = [AdUnit]()
            defaultValue.append(AdUnit(id: "", name: "PROD Banner", format: .banner, source: .production))
            defaultValue.append(AdUnit(id: "", name: "PROD MREC", format: .rectangle, source: .production))
            defaultValue.append(AdUnit(id: "", name: "PROD Interstitial", format: .interstitial, source: .production))
            defaultValue.append(AdUnit(id: "", name: "PROD Rewarded", format: .rewarded, source: .production))
            
            do {
                guard let data = self.object(forKey: UserDefaults.savedAdsKey) as? Data else {
                    print("<SaveAdsManager> \(#function) Failed to fetch Data from UserDefaults.")
                    return defaultValue
                }
                
                let result = try JSONDecoder().decode([AdUnit].self, from: data)
                
                return !result.isEmpty ? result : defaultValue
            } catch {
                print("<SaveAdsManager> \(#function) caught error: \(error)")
                return defaultValue
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                self.set(data, forKey: UserDefaults.savedAdsKey)
            } catch {
                print("<SaveAdsManager> \(#function) caught error: \(error)")
            }
        }
    }
}
