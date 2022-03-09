//
//  SettingsBundle.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 27/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

enum SampleSetting:String {
    case AppId        = "App Id"
    case SpotId       = "Spot Id"
    case Portal       = "Portal"
    case Server       = "Server"
    case CCPAString   = "CCPA String"
    case GlobalConfig = "Global Config"
    case GDPRData     = "GDPR Data"
    case GDPR         = "GDPR"
    case SDKVersion   = "SDK Version"
    case ShouldLoadCurrentAdAfterStartup = "Load Last Ad On Startup"
    
    
    //New Ad Unit related
    case NewAdFormat = "Ad Format"
    case NewMockName   = "Mock"
    
    //SDK Bidding related - need to exclude on the Publihser Test APP
    
   
    var ClientSettingsValue:String? {
        return ClientRequestSettings.shared.getValue(of: self)
    }
}
