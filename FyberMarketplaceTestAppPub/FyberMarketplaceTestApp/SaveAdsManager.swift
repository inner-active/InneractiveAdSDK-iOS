//
//  SaveAdsManager.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 25/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

protocol SavedAdsManagerDelegate: AnyObject {
    func AdSuccefullySaved()
    func AdSuccessfullyRemoved()
}

final class SavedAdsManager {
    
    static let sharedInstance = SavedAdsManager()
    
    private(set) var savedAds: [AdUnit]
    private let userDefaults: UserDefaults
    weak var delegate: SavedAdsManagerDelegate!
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        savedAds = userDefaults.savedAds
    }
    
    func addSavedAd(adUnit: AdUnit) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.savedAds.removeAll(where: {(adUnit.id == $0.id && adUnit.format == $0.format) }) // avoid duplicate
            self.savedAds.insert(adUnit, at: 0)
            self.userDefaults.savedAds = self.savedAds
            DispatchQueue.main.async {
                self.delegate.AdSuccefullySaved()
            }
        }
    }
    
    func removeSavedAd(adUnit: AdUnit) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.savedAds.removeAll(where: { (adUnit.id == $0.id && adUnit.format == $0.format) })
            self.userDefaults.savedAds = self.savedAds
            DispatchQueue.main.async {
                self.delegate.AdSuccessfullyRemoved()
            }
        }
    }
}

// MARK: - UserDefaults
private extension UserDefaults {
    var savedAds: [AdUnit] {
        get {
            var defaultValue = [AdUnit]()
            
            defaultValue.append(AdUnit(id: "", "Production Banner", .Banner, .Production))
            defaultValue.append(AdUnit(id: "", "Production Rectangle", .Rectangle, .Production))
            defaultValue.append(AdUnit(id: "", "Production Interstitial", .Interstitial, .Production))
            defaultValue.append(AdUnit(id: "", "Production Rewarded", .Rewarded, .Production))
            
            do {
                guard let data = self.object(forKey:"SavedAdsKey" ) as? Data else {
                    print("<SaveAdsManager> \(#function) Failed to fetch Data from UserDefaults.")
                    return defaultValue
                }
                
                let result = try JSONDecoder().decode([AdUnit].self, from: data)
                
                return result.count > 0 ? result : defaultValue
            } catch {
                print("<SaveAdsManager> \(#function) caught error: \(error)")
                return defaultValue
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                self.set(data, forKey: "SavedAdsKey")
            } catch {
                print("<SaveAdsManager> \(#function) caught error: \(error)")
            }
        }
    }
}

