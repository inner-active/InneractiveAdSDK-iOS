//
//  SampleAdType.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 29/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

enum SampleAdType: String, CodingKey, Decodable, Encodable {
    case Banner = "Banner"
    case Rectangle = "Rectangle"
    case Interstitial = "Interstitial"
    case InterstitialDisplay = "Interstitial Display"
    case InterstitialVideo = "Interstitial Video"
    case Rewarded = "Rewarded"
    
    // Custom maximum ad sizes can be requested using an explicit `CGSize`.
    var size: CGSize {
        switch self {
        case .Banner: return ((UIDevice.current.userInterfaceIdiom == .pad) ? CGSize(width: kIADefaultIPadBannerWidth, height: kIADefaultIPadBannerHeight) : CGSize(width: kIADefaultIPhoneBannerWidth, height: kIADefaultIPhoneBannerHeight))
        case .Rectangle: return CGSize(width: kIADefaultRectWidth, height: kIADefaultRectHeight)
        default: return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    var spotId: String {
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
