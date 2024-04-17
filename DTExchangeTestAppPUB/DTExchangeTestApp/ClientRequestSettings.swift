//
//  ClientRequestSettingss.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 27/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation
import IASDKCore

typealias AdUnitValues = (adUnitId: String?, spotId: String?, server: String?, portal: String?)

protocol ClientRequestSettingsDelegate: AnyObject {
    func valueDidChange(for field: SampleSettingsEnum, with value: String)
}

class ClientRequestSettings {
    static let shared = ClientRequestSettings()
    
    private init() {
    }
    
    // MARK: - Properties
    /**
     Represents App id  as specified on Fyber dashboard.
     */
    internal var appId: String? {
        didSet {
            MarketplaceSDK.initSDKCore(with: appId!)
        }
    }
    /**
     Represents Spot id as specified on Fyber dashboard.
     */
    private var spotId: String?

    /**
     Represents Marketplace server  - wv.inner-active = Production | ia-cert = Stagin
     */
    private var server: String? = Constants.SDKSettings.kProduction

    /**
     Optional text used to choose different portal  on Forest.
     */
    private var portal: String? = Constants.SDKSettings.defaultPort

    /**
     Optional text to for user extra data on ccpa param.
     */
    private var ccpaString: String? = IASDKCore.sharedInstance().ccpaString ?? "1YYY" {
        didSet {
            IASDKCore.sharedInstance().ccpaString = ccpaString
        }
    }

    /**
     Optional URL Path to override globalConfig
     */
    private var globalConfig: String? {
        didSet {
            if let globalConfig = globalConfig, !globalConfig.isEmpty {
                loadGlobalConfig(from: globalConfig)
            }
        }
    }

    /**
     Optional text to for user extra data on gdpr param
     */
    private var gdprData: String? = IASDKCore.sharedInstance().gdprConsentString ?? "" {
        didSet {
            if gdprData!.isEmpty {
                IASDKCore.sharedInstance().clearGDPRConsentData()
            } else {
                IASDKCore.sharedInstance().gdprConsentString = gdprData
            }
        }
    }
    // (of: IASDKCore.sharedInstance().gdprConsent.rawValue + 1)
    private var gdpr: String? = Constants.SDKSettings.gdprArray[IASDKCore.sharedInstance().gdprConsent.rawValue + 1] {
        didSet {
        }
    }

    /**
     User privacy preferences. Corresponds to and taken from IASDKCore.
     */
    private var lgpd: String? = Constants.SDKSettings.lgpdArray[IASDKCore.sharedInstance().lgpdConsent.rawValue + 1] {
        didSet {
        }
    }

    /**
     User privacy preferences. Corresponds to and taken from IASDKCore.
     */
    private var coppa: String? = Constants.SDKSettings.coppaArray[IASDKCore.sharedInstance().coppaApplies.rawValue + 1] {
        didSet {
        }
    }

    /**
     Represents Mock Name as specified in Forest .
     */
    private var adUnitId: String?

    /**
     Optional - Represents New Ad Unit Mock Name.
     */
    private var newMockName: String?

    /**
     Optional - Represents New Ad Unit Type. Banner by default.
     */
    private var newAdFormat: String? = SampleAdTypeEnum.banner.rawValue {
        didSet {
            if shouldAutoFillSpotIdTextField {
                newAdUnitSpotId = SampleAdTypeEnum(rawValue: newAdFormat!)?.defaultSpotId
            }
        }
    }

    /**
     Optional - Represents New Ad Unit's Spot Id
     */
    private var newAdUnitSpotId: String?

    /**
     Optional - Represents New Ad Unit's Portal
     */
    private var newAdUnitPortal: String? = "4321"

    /**
     Optional - When editing an Ad Unit, we want to block the autofill for the spotId textfield.
     */
    private var shouldAutoFillSpotIdTextField: Bool = true

    /**
     Optional - User Targeting
     */
    private var userID: String? {
        get {
            guard let userId = IASDKCore.sharedInstance().userID else { return ""}
            return userId
        }
        set {
            IASDKCore.sharedInstance().userID = newValue
        }
    }
    
    private var muteAudio: Bool! {
        get {
            return IASDKCore.sharedInstance().muteAudio
        }
        set {
            IASDKCore.sharedInstance().muteAudio = newValue
        }
    }

    private func loadGlobalConfig(from path: String) {
        IADebugger.globalConfigPath = path
    }

    private func isValidAdUnitValuesFromUserDefault(adValues: AdUnitValues) -> Bool {
        return adValues.spotId != nil && adValues.adUnitId != nil &&
                adValues.server != nil && adValues.portal != nil
    }

    private func pullLastAdValuesFromUserDefault() -> (AdUnitValues) {
        let userDefaultsServer = UserDefaults.standard.string(forKey: UserDefaultsKey.server.rawValue)
        let userDefaultsSpotID = UserDefaults.standard.string(forKey: UserDefaultsKey.spotID.rawValue)
        let userDefaultsAdUnitID = UserDefaults.standard.string(forKey: UserDefaultsKey.adUnitID.rawValue)
        let userDefaultsPortal = UserDefaults.standard.string(forKey: UserDefaultsKey.portal.rawValue)

        return (userDefaultsServer, userDefaultsSpotID, userDefaultsAdUnitID, userDefaultsPortal)
    }

    private func removeLastAdFromUserDefault() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.server.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.spotID.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.adUnitID.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.portal.rawValue)
    }
    
    private func saveToUserDefaultRequest(with mock: String, portal: String) {
        let dictionary = [SDKDebugKeys.DTXPortalKey.rawValue: portal, SDKDebugKeys.DTXMockResponseKey.rawValue: mock]
        
        UserDefaults.standard.set(dictionary, forKey: SDKDebugKeys.DTXUserDefaultsPortalAndMockKey.rawValue)
    }
        
    private func saveToCoreDebugger(with mock: String, portal: String) {
        IASDKCore.sharedInstance().debugger = IADebugger.build({ (builder: IADebuggerBuilder) in
            builder.database = portal
            builder.mockResponsePath = mock
        })
    }
    
    // MARK: - Getters & Setters
    internal func getValue(of setting: SampleSettingsEnum) -> String? {
        switch setting {
        case .server: return server
        case .appId: return appId
        case .adFormat: return newAdFormat
        case .spotId: return spotId
        case .spotIdNew: return newAdUnitSpotId ?? SampleAdTypeEnum(rawValue: newAdFormat!)!.defaultSpotId
        case .portal: return portal
        case .portalNew: return newAdUnitPortal
        case .mockName: return newMockName
        case .ccpaString: return ccpaString
        case .globalConfig: return globalConfig
        case .gdprData: return gdprData
        case .gdpr: return gdpr
        case .lgpd: return lgpd
        case .coppa: return coppa
        case .sdkVersion: return IASDKCore.sharedInstance().version()
        case .userId: return userID
        case .muteAudio: return muteAudio.description
        }
    }

    // MARK: - API
    func resetNewMockName() {
        newMockName = nil
    }

    func willEditAdUnit() {
        shouldAutoFillSpotIdTextField = false
    }

    func didShowEditingViewController() {
        shouldAutoFillSpotIdTextField = true
    }

    func updateRequestObject(with request: IAAdRequest) {
        let server = self.server == Constants.SDKSettings.kProduction ? "" : self.server
        request.spotID = spotId ?? ""
        if let debugger = request.debugger {
            debugger.server = server
            debugger.database = portal
            debugger.mockResponsePath = adUnitId
        }
    }

    func updateClientRequest(with adUnit: AdUnit) {
        spotId = adUnit.spotId
        if let idLocal = adUnit.id { adUnitId = idLocal }
        portal = adUnit.source == .mock ? adUnit.portal : ""
    }
    
    func saveCurrentAdToUserDefaults() {
        let defaults = UserDefaults.standard
        
        if server != nil, portal != nil {
            defaults.set(server, forKey: UserDefaultsKey.server.rawValue)
            defaults.set(spotId, forKey: UserDefaultsKey.spotID.rawValue)
            defaults.set(adUnitId, forKey: UserDefaultsKey.adUnitID.rawValue)
            defaults.set(portal, forKey: UserDefaultsKey.portal.rawValue)
            
            Console.shared.add(message: """
            Saving spotID \(spotId!), adUnitId \(adUnitId!), server \(server!), portal \(portal!) to user defaults
            """)
        }
    }

    func saveMockInfo(with mock: String, portal: String) {
        saveToUserDefaultRequest(with: mock, portal: portal)
        saveToCoreDebugger(with: mock, portal: portal)
    }

    func removeUserDefaultsIfNeeded() {
        UserDefaults.standard.removeObject(forKey: SDKDebugKeys.DTXUserDefaultsPortalAndMockKey.rawValue)
    }


    internal func useValuesFromUserDefaults() -> Bool {
        let adValues = pullLastAdValuesFromUserDefault()
        
        if isValidAdUnitValuesFromUserDefault(adValues: adValues) {
            removeLastAdFromUserDefault()
            self.server = adValues.server
            self.spotId = adValues.spotId ?? ""
            adUnitId = adValues.adUnitId ?? ""
            
            portal = !adUnitId!.isEmpty ? adValues.portal : ""
            AdViewController.shouldAutoLoad = true
            
            Console.shared.add(message: """
            Using server \(server!), spotID \(spotId!), adUnitId \(adUnitId!), portal \(portal!) from user defaults
            """)
            return true
        } else {
            Console.shared.add(message: "Tried to fetch spot ID, adUnitID and server values from user defaults but something is missing")
            return false
        }
    }
}

// MARK: - SampleSettingDelegate
extension ClientRequestSettings: ClientRequestSettingsDelegate {
    func valueDidChange(for field: SampleSettingsEnum, with value: String) {
        switch field {
        case .server: server = value
        case .appId: appId = value
        case .adFormat: newAdFormat = value
        case .spotId: spotId = value
        case .spotIdNew: newAdUnitSpotId = value
        case .portal: portal = value
        case .portalNew: newAdUnitPortal = value
        case .mockName: newMockName = value
        case .ccpaString: ccpaString = value
        case .globalConfig: globalConfig = value
        case .gdprData: gdprData = value
        case .gdpr: gdpr = value
        case .lgpd: lgpd = value
        case .coppa: coppa = value
        case .userId: userID = value
        case .muteAudio: muteAudio.toggle()
        case .sdkVersion: return
        }
    }
}

// MARK: - ScannerViewControllerCompetionHandlers
extension ClientRequestSettings: ScannerViewControllerDelegate {
    func successfullyFetchedData(json: JSON) {
        let mock = json[QRRequestDataKey.mock.rawValue] as? String
        let portal = json[QRRequestDataKey.portal.rawValue] as? Int
        guard mock != nil || portal != nil else { return }
        newMockName = mock
        newAdUnitPortal = String(portal!)
    }

    func failedToFetchData(error: GetDataFailureReason) {
        Console.shared.add(message: "failed to read mock:\n \(error.localizedDescription)")
    }
}
