//
//  SDKDebug.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 26/01/2022.
//  Copyright © 2022 Fyber. All rights reserved.
//

import Foundation

enum SDKDebugKeys: String {
    case FMPKeySDKEventsForTesting = "kFMPKeySDKEventsForTesting"
    case FYBUserDefaultsPortalAndMockKey = "FYBUserDefaultsPortalAndMockKey"
    case FYBPortalKey = "FYBPortalKey"
    case FYBMockResponseKey = "FYBMockResponseKey"
    case FMPSetProxyNotification = "FMPSetProxyNotification"
    case FMPRemoveProxyNotification = "FMPRemoveProxyNotification"
}

enum UserDefaultsKey: String {
    case ShouldLoadCurrentAdAfterStartup = "FMPShouldLoadCurrentAdAfterStartup"
    case SpotID = "FMPSpotID"
    case AdUnitID = "FMPAdUnitID"
    case Server = "FMPServer"
    case Portal = "FMPPortal"
    case SampleAdTypeEnum = "FMPSampleAdTypeEnum"
    case SDKEventsDebugMode = "FMPSDKEventsDebugMode"
    case SDKBiddingMode = "FMPSDKBiddingMode"
    case SDKBiddingDeviceIP = "FMPSDKBiddingDeviceIP"
    case ClientProxyState = "FMPClientProxyState"
    case ClientProxySetting = "ClientProxySetting"
    case ClientProxyServerAddress = "FMPClientProxyServer"
    case ClientProxyPort = "FMPClientProxyPort"
}
