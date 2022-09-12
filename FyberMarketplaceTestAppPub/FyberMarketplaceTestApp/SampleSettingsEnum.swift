//
//  SampleSettingsEnum.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 27/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

enum SampleSettingsEnum:String {
    case Server       = "Server"
    case AppId        = "App Id"
    case AdFormat     = "Ad Format"
    case SpotId       = "Spot Id"
    case SpotIdNew    = "Spot Id For New Ad Unit"
    case Portal       = "Portal"
    case PortalNew    = "Portal For New Ad Unit"
    case MockName     = "Mock"
    case CCPAString   = "CCPA String"
    case GlobalConfig = "Global Config"
    case GDPRData     = "GDPR Data"
    case GDPR         = "GDPR"
    case LGPD         = "LGPD"
    case SDKVersion   = "SDK Version"
    case UserId       = "User Id"
    
    var ClientSettingsValue:String? {
        return ClientRequestSettings.shared.getValue(of: self)
    }
}
