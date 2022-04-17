//
//  ClientRequestSettingss.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 27/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

let k_production = "wv.inner-active"

enum UserDefaultsKey:String {
    case ShouldLoadCurrentAdAfterStartup = "FMPShouldLoadCurrentAdAfterStartup"
    case SpotID = "FMPSpotID"
    case AdUnitID = "FMPAdUnitID"
    case Server = "FMPServer"
    case SampleAdType = "FMPSampleAdType"
    case SDKEventsDebugMode = "FMPSDKEventsDebugMode"
}

protocol ClientRequestSettingsDelegate:AnyObject {
    func valueDidChange(for field:SampleSetting, with value:String)
}

class ClientRequestSettings {

    static let shared = ClientRequestSettings()
    
    private init() {
        let defaults = UserDefaults.standard

        shouldLoadCurrentAdAfterStartup = defaults.bool(forKey: UserDefaultsKey.ShouldLoadCurrentAdAfterStartup.rawValue)
    }
    
    //MARK: - Properties
    
    /**
     Represents App id  as specified on Fyber dashboard.
     */
    internal var appId: String? = nil {
        didSet {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.initSDKCore(with: appId!)
        }
    }
    /**
     Represents Spot id as specified on Fyber dashboard.
     */
    private var spotId: String? = nil

    /**
     Represents Marketplace server  - wv.inner-active = Production | ia-cert = Stagin
     */
    private var server: String? = k_production
    
 
    /**
     Optional text used to choose different portal  on Forest.
     */
    private var portal: String? = "4321"
    
    /**
     Optional text to for user extra data on ccpa param.
     */
    private var ccpaString: String? {
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
    private var gdprData: String? = "" {
        didSet {
            if gdprData!.isEmpty {
                IASDKCore.sharedInstance().clearGDPRConsentData()
            } else {
                IASDKCore.sharedInstance().gdprConsentString = gdprData
            }
        }
    }
    
    /**
     User privacy preferences. 'Given' By default.
     */
    private var gdpr: String? = "Given" {
        didSet {
        }
    }

    /**
     User privacy preferences. 'Given' By default.
     */
    private var lgpd: String? = "Given" {
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
    private var newAdFormat: String? = SampleAdType.Banner.rawValue
    
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
    
    // Debugging realated -
    
    /**
     When set to True - App will launch on User last Ad View.
     Ad Unit will load automatically.
     */

    private var shouldLoadCurrentAdAfterStartup: Bool! = false {
        didSet {
            let defaults = UserDefaults.standard
            
            defaults.set(shouldLoadCurrentAdAfterStartup, forKey: UserDefaultsKey.ShouldLoadCurrentAdAfterStartup.rawValue)
        }
    }
    
    
    //SDK Bidding related - need to exclude on the Publihser Test APP
    //MARK: - Service
    
    internal func updateClientRequest(with adUnit:AdUnit) {
        spotId = adUnit.format.spotId
        adUnitId = adUnit.id
        portal = adUnit.source == .Mock ? "4321" : ""
    }
    
    internal func updateRequestObject(with request:IAAdRequest) {
        let server = self.server == k_production ? "" : self.server
        
        if let spotid = spotId {
            request.spotID = spotid
        }
     
        if let debugger = request.debugger {
            debugger.server = server;
            debugger.database = portal
            debugger.mockResponsePath = adUnitId
        }
    }
    
    internal func getDebugValuesForSDKBidding() -> IADebugger {
        let debugger = IADebugger.build({ (builder: IADebuggerBuilder) in
            builder.database = self.portal
            builder.server = self.server
            builder.mockResponsePath = self.adUnitId
        })
        
        return debugger!
    }
    
    private func loadGlobalConfig(from path:String) {
        IADebugger.globalConfigPath = path
    }
    
    //MARK: - Getters & Setters

    internal func getValue(of setting:SampleSetting) -> String? {
        switch setting {
        case .AppId: return appId
        case .SpotId: return spotId
        case .Portal: return portal
        case .Server: return server
        case .CCPAString: return ccpaString
        case .GlobalConfig: return globalConfig
        case .GDPRData: return gdprData
        case .GDPR: return gdpr
        case .LGPD: return lgpd
        case .SDKVersion: return IASDKCore.sharedInstance().version()
        case .NewAdFormat: return newAdFormat
        case .NewMockName: return newMockName
        case .ShouldLoadCurrentAdAfterStartup: return shouldLoadCurrentAdAfterStartup.description
        

        }
    }

    //MARK: - API

    internal func resetNewMockName() {
        newMockName = nil
    }

    internal func saveCurrentAdToUserDefaults() {
        let defaults = UserDefaults.standard
        
        if spotId != nil && adUnitId != nil && server != nil {
            defaults.set(spotId, forKey: UserDefaultsKey.SpotID.rawValue)
            defaults.set(adUnitId, forKey: UserDefaultsKey.AdUnitID.rawValue)
            defaults.set(server, forKey: UserDefaultsKey.Server.rawValue)
            
            Console.shared.add(message: "Saving spotID \(spotId!), adUnitId \(adUnitId!), server \(server!) to user defaults")
        }
    }
    
    internal func saveToUserDefaultRequest(with mock:String, portal:String) {
        let dictionary = [SDKDebugKeys.FYBPortalKey.rawValue: portal, SDKDebugKeys.FYBMockResponseKey.rawValue: mock]
    
        UserDefaults.standard.set(dictionary, forKey: SDKDebugKeys.FYBUserDefaultsPortalAndMockKey.rawValue)
    }
    
    internal func removeUserDefaultsIfNeeded() {
        UserDefaults.standard.removeObject(forKey: SDKDebugKeys.FYBUserDefaultsPortalAndMockKey.rawValue)
    }
    
    internal func useValuesFromUserDefaults() -> Bool {
        let defaults = UserDefaults.standard
        
        let userDefaultsSpotID = defaults.string(forKey: UserDefaultsKey.SpotID.rawValue)
        let userDefaultsAdUnitID = defaults.string(forKey: UserDefaultsKey.AdUnitID.rawValue)
        let userDefaultsServer = defaults.string(forKey: UserDefaultsKey.Server.rawValue)

        defaults.removeObject(forKey: UserDefaultsKey.SpotID.rawValue)
        defaults.removeObject(forKey: UserDefaultsKey.AdUnitID.rawValue)
        defaults.removeObject(forKey: UserDefaultsKey.Server.rawValue)

        if userDefaultsSpotID != nil && userDefaultsServer != nil && userDefaultsAdUnitID != nil {
            server = userDefaultsServer
            spotId = userDefaultsSpotID
            adUnitId = userDefaultsAdUnitID
            portal = adUnitId != "" ?  "4321" : ""
            
            AdViewController.shouldAutoLoad = true

            Console.shared.add(message: "Using spotID \(spotId!), adUnitId \(adUnitId!), server \(server!) from user defaults")
            return true
        } else {
            Console.shared.add(message: "Tried to fetch spot ID, adUnitID and server values from user defaults but something is missing")
            return false
        }
    }

}

//MARK: - SampleSettingDelegate

extension ClientRequestSettings: ClientRequestSettingsDelegate {
    func valueDidChange(for field: SampleSetting, with value: String) {
        switch field {
        case .AppId: appId = value
        case .SpotId: spotId = value
        case .Portal: portal = value
        case .CCPAString: ccpaString = value
        case .GlobalConfig: globalConfig = value
        case .GDPRData: gdprData = value
        case .NewMockName: newMockName = value
        case .Server: server = value
        case .GDPR: gdpr = value
        case .LGPD: lgpd = value
        case.NewAdFormat: newAdFormat = value
        case .ShouldLoadCurrentAdAfterStartup: shouldLoadCurrentAdAfterStartup.toggle()
        case .SDKVersion: return
        
            
        }
    }
}

//MARK: - ScannerViewControllerDelegate

extension ClientRequestSettings: ScannerViewControllerDelegate {
    func receivedQRCode(with mock: String) {
        newMockName = mock
    }
}

