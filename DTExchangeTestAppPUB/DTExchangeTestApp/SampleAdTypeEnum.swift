//
//  SampleAdTypeEnum.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 29/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

enum SampleAdTypeEnum: String, CodingKey, Codable {
    case banner = "Banner"
    case rectangle = "Rectangle"
    case interstitial = "Interstitial"
    case interstitialDisplay = "Interstitial Display"
    case interstitialVideo = "Interstitial Video"
    case rewarded = "Rewarded"
    
    /**
     *  @discussion Custom maximum ad sizes can be requested using an explicit `CGSize`.
     */
    var size: CGSize {
        switch self {
        case .banner: return bannerSize()
        case .rectangle: return CGSize(width: kIADefaultRectWidth, height: kIADefaultRectHeight)
        default: return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    func bannerSize() -> CGSize {
        var size = CGSize.zero
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            size = CGSize(width: kIADefaultIPadBannerWidth, height: kIADefaultIPadBannerHeight)
        } else {
            size = CGSize(width: kIADefaultIPhoneBannerWidth, height: kIADefaultIPhoneBannerHeight)
        }
        
        return size
    }
    
    var defaultSpotId: String {
        switch self {
        case .banner: return "150942"
        case .rectangle: return "150943"
        case .interstitial: return "150946"
        case .interstitialDisplay: return "160343"
        case .interstitialVideo: return "296562"
        case .rewarded: return "150949"
        }
    }
    
    func isInterstitial() -> Bool {
        switch self {
        case .banner, .rectangle: return false
        default: return true
        }
    }
}
