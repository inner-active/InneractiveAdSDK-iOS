//
//  SDKDebug.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 26/01/2022.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

enum SDKDebugKeys: String {
    case DTXKeySDKEventsForTesting = "kDTXKeySDKEventsForTesting"
    case DTXUserDefaultsPortalAndMockKey = "DTXUserDefaultsPortalAndMockKey"
    case DTXPortalKey = "DTXPortalKey"
    case DTXMockResponseKey = "DTXMockResponseKey"
    case DTXSetProxyNotification = "DTXSetProxyNotification"
    case DTXRemoveProxyNotification = "DTXRemoveProxyNotification"
}

enum UserDefaultsKey: String {
    case shouldLoadCurrentAdAfterStartup = "FMPShouldLoadCurrentAdAfterStartup"
    case audioSessionManagementEnabled = "AudioSessionManagementEnabled"
    case spotID = "FMPSpotID"
    case adUnitID = "FMPAdUnitID"
    case server = "FMPServer"
    case portal = "FMPPortal"
    case sampleAdTypeEnum = "FMPSampleAdTypeEnum"
    case sdkEventsDebugMode = "FMPSDKEventsDebugMode"
    case sdkBiddingMode = "FMPSDKBiddingMode"
    case sdkBiddingDeviceIP = "FMPSDKBiddingDeviceIP"
    case clientProxyState = "FMPClientProxyState"
    case clientProxySetting = "ClientProxySetting"
    case clientProxyServerAddress = "FMPClientProxyServer"
    case clientProxyPort = "FMPClientProxyPort"
}
