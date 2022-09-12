//
//  ClientRequestSettingss.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 27/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

typealias AdUnitValues = (adUnitId: String?, spotId: String?, server: String?, portal: String?)

protocol ClientRequestSettingsDelegate:AnyObject {
    func valueDidChange(for field:SampleSettingsEnum, with value:String)
}

class ClientRequestSettings {
    static let shared = ClientRequestSettings()
    
    private init() {
    }
    
    //MARK: - Properties
    /**
     Represents App id  as specified on Fyber dashboard.
     */
    internal var appId: String? = nil {
        didSet {
            MarketplaceSDK.initSDKCore(with: appId!)
        }
    }
    /**
     Represents Spot id as specified on Fyber dashboard.
     */
    private var spotId: String? = nil

    /**
     Represents Marketplace server  - wv.inner-active = Production | ia-cert = Stagin
     */
    private var server: String? = Constants.SDKSettings.k_production
    
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
    private var globalConfig: String? = nil {
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
    
    /**
     User privacy preferences. Corresponds to and taken from IASDKCore.
     */
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
     Represents Mock Name as specified in Forest .
     */
    private var adUnitId: String? = nil
   
    /**
     Optional - Represents New Ad Unit Mock Name.
     */
    private var newMockName: String?
    
    /**
     Optional - Represents New Ad Unit Type. Banner by default.
     */
    private var newAdFormat: String? = SampleAdTypeEnum.Banner.rawValue {
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
    private var userID: String  {
        get {
            guard let userId = IASDKCore.sharedInstance().userID else { return ""}
            return userId
        }
        set {
            IASDKCore.sharedInstance().userID = newValue
        }
    }

    private func loadGlobalConfig(from path:String) {
        IADebugger.globalConfigPath = path
    }
    
    private func isValidAdUnitValuesFromUserDefault(adValues: AdUnitValues) -> Bool {
        return adValues.spotId != nil && adValues.adUnitId != nil &&
                adValues.server != nil && adValues.portal != nil
    }
    
    private func pullLastAdValuesFromUserDefault() -> (AdUnitValues) {
        let userDefaultsServer = UserDefaults.standard.string(forKey: UserDefaultsKey.Server.rawValue)
        let userDefaultsSpotID = UserDefaults.standard.string(forKey: UserDefaultsKey.SpotID.rawValue)
        let userDefaultsAdUnitID = UserDefaults.standard.string(forKey: UserDefaultsKey.AdUnitID.rawValue)
        let userDefaultsPortal = UserDefaults.standard.string(forKey: UserDefaultsKey.Portal.rawValue)
        
        return (userDefaultsServer, userDefaultsSpotID, userDefaultsAdUnitID, userDefaultsPortal)
    }
    
    private func removeLastAdFromUserDefault() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.Server.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.SpotID.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.AdUnitID.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.Portal.rawValue)
    }
    //MARK: - Getters & Setters
    internal func getValue(of setting:SampleSettingsEnum) -> String? {
        switch setting {
        case .Server: return server
        case .AppId: return appId
        case .AdFormat: return newAdFormat
        case .SpotId: return spotId
        case .SpotIdNew: return newAdUnitSpotId ?? SampleAdTypeEnum(rawValue: newAdFormat!)!.defaultSpotId
        case .Portal: return portal
        case .PortalNew: return newAdUnitPortal
        case .MockName: return newMockName
        case .CCPAString: return ccpaString
        case .GlobalConfig: return globalConfig
        case .GDPRData: return gdprData
        case .GDPR: return gdpr
        case .LGPD: return lgpd
        case .SDKVersion: return IASDKCore.sharedInstance().version()
        case .UserId: return userID
        }
    }

    //MARK: - API
    func resetNewMockName() {
        newMockName = nil
    }
    
    func willEditAdUnit() {
        shouldAutoFillSpotIdTextField = false
    }
    
    func didShowEditingViewController() {
        shouldAutoFillSpotIdTextField = true
    }
    
    func updateRequestObject(with request:IAAdRequest) {
        let server = self.server == Constants.SDKSettings.k_production ? "" : self.server
        
        if let spotid = spotId {
            request.spotID = spotid
        }
     
        if let debugger = request.debugger {
            debugger.server = server;
            debugger.database = portal
            debugger.mockResponsePath = adUnitId
        }
    }
    
    func updateClientRequest(with adUnit:AdUnit) {
        spotId = adUnit.spotId
        adUnitId = adUnit.id
        portal = adUnit.source == .Mock ? adUnit.portal : ""
    }
    
    func saveCurrentAdToUserDefaults() {
        let defaults = UserDefaults.standard
        
        if spotId != nil && adUnitId != nil && server != nil , portal != nil {
            defaults.set(server, forKey: UserDefaultsKey.Server.rawValue)
            defaults.set(spotId, forKey: UserDefaultsKey.SpotID.rawValue)
            defaults.set(adUnitId, forKey: UserDefaultsKey.AdUnitID.rawValue)
            defaults.set(portal, forKey: UserDefaultsKey.Portal.rawValue)
            
            Console.shared.add(message: "Saving spotID \(spotId!), adUnitId \(adUnitId!), server \(server!), portal \(portal!) to user defaults")
        }
    }
    
    func saveToUserDefaultRequest(with mock:String, portal:String) {
        let dictionary = [SDKDebugKeys.FYBPortalKey.rawValue: portal, SDKDebugKeys.FYBMockResponseKey.rawValue: mock]
    
        UserDefaults.standard.set(dictionary, forKey: SDKDebugKeys.FYBUserDefaultsPortalAndMockKey.rawValue)
    }
    
    func removeUserDefaultsIfNeeded() {
        UserDefaults.standard.removeObject(forKey: SDKDebugKeys.FYBUserDefaultsPortalAndMockKey.rawValue)
    }
    
    
    internal func useValuesFromUserDefaults() -> Bool {
        let adValues = pullLastAdValuesFromUserDefault()
        
        if isValidAdUnitValuesFromUserDefault(adValues: adValues) {
            removeLastAdFromUserDefault()
            self.server = adValues.server
            self.spotId = adValues.spotId
            adUnitId = adValues.adUnitId
            
            portal = adUnitId != "" ? adValues.portal : ""
            AdViewController.shouldAutoLoad = true

            Console.shared.add(message: "Using server \(server!), spotID \(spotId!), adUnitId \(adUnitId!), portal \(portal!) from user defaults")
            return true
        } else {
            Console.shared.add(message: "Tried to fetch spot ID, adUnitID and server values from user defaults but something is missing")
            return false
        }
    }
}

//MARK: - SampleSettingDelegate
extension ClientRequestSettings: ClientRequestSettingsDelegate {
    func valueDidChange(for field: SampleSettingsEnum, with value: String) {
        switch field {
        case .Server: server = value
        case .AppId: appId = value
        case .AdFormat: newAdFormat = value
        case .SpotId: spotId = value
        case .SpotIdNew: newAdUnitSpotId = value
        case .Portal: portal = value
        case .PortalNew: newAdUnitPortal = value
        case .MockName: newMockName = value
        case .CCPAString: ccpaString = value
        case .GlobalConfig: globalConfig = value
        case .GDPRData: gdprData = value
        case .GDPR: gdpr = value
        case .LGPD: lgpd = value
        case .UserId: userID = value
        case .SDKVersion: return
        }
    }
}

//MARK: - ScannerViewControllerCompetionHandlers
extension ClientRequestSettings: ScannerViewControllerDelegate {
    func successfullyFetchedData(json: JSON) {
        guard let mock =  json[QRRequestDataKey.Mock.rawValue] as? String  else { return }
        newMockName = mock
    }
    
    func failedToFetchData(error: GetDataFailureReason) {
        Console.shared.add(message: "<Fyber> Failed to read Mock with error:\n \(error.localizedDescription)")
    }
}
