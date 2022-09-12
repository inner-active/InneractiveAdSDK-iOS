//
//  SampleAdTypeEnum.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 29/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

enum SampleAdTypeEnum: String, CodingKey, Codable {
    case Banner = "Banner"
    case Rectangle = "Rectangle"
    case Interstitial = "Interstitial"
    case InterstitialDisplay = "Interstitial Display"
    case InterstitialVideo = "Interstitial Video"
    case Rewarded = "Rewarded"
    
    /**
     *  @discussion Custom maximum ad sizes can be requested using an explicit `CGSize`.
     */
    var size: CGSize {
        switch self {
        case .Banner: return bannerSize()
        case .Rectangle: return CGSize(width: kIADefaultRectWidth, height: kIADefaultRectHeight)
        default: return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    func bannerSize() -> CGSize {
        var size = CGSize.zero
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            size = CGSize(width: kIADefaultIPadBannerWidth, height: kIADefaultIPadBannerHeight)
        } else {
            size = CGSize(width: kIADefaultIPhoneBannerWidth, height: kIADefaultIPhoneBannerHeight)
        }
        
        return size
    }
    
    var defaultSpotId: String {
        switch self {
        case .Banner: return "150942"
        case .Rectangle: return "150943"
        case .Interstitial: return "150946"
        case .InterstitialDisplay: return "160343"
        case .InterstitialVideo: return "296562"
        case .Rewarded: return "150949"
        }
    }
    
    func isInterstitial() -> Bool {
        switch self {
        case .Banner, .Rectangle: return false
        default: return true
        }
    }
}
