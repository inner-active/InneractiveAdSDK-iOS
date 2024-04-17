//
//  SampleSettingsEnum.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 27/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

enum SampleSettingsEnum: String {
    case server       = "Server"
    case appId        = "App Id"
    case adFormat     = "Ad Format"
    case spotId       = "Spot Id"
    case spotIdNew    = "Spot Id For New Ad Unit"
    case portal       = "Portal"
    case portalNew    = "Portal For New Ad Unit"
    case mockName     = "Mock"
    case ccpaString   = "CCPA String"
    case globalConfig = "Global Config"
    case gdprData     = "GDPR Data"
    case gdpr         = "GDPR"
    case lgpd         = "LGPD"
    case coppa        = "COPPA"
    case sdkVersion   = "SDK Version"
    case userId       = "User Id"
    case muteAudio    = "Mute Audio"
    
    var ClientSettingsValue: String? {
        return ClientRequestSettings.shared.getValue(of: self)
    }
}
