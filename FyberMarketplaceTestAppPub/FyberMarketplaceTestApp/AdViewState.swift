//
//  AdViewState.swift
//  FyberMarketplaceTestApp
//
//  Created by Or.Avraham on 01/02/2022.
//  Copyright © 2022 Inneractive. All rights reserved.
//

import Foundation

enum AdViewContentState {
    case BannerAndPortrait
    case BannerAndLandscape
    case RectangleAndPortrait
    case RectangleAndLandscape
    case InterstitialAndLandscape
    case InterstitialAndPortrait
    
    func getTopConstraint(from adType: SampleAdTypeEnum) -> CGFloat {
        switch self {
        case .BannerAndPortrait: // Use percentages to support different screen sizes
            return ((UIScreen.main.fixedCoordinateSpace.bounds.height - adType.size.height) * 0.6)
        case .BannerAndLandscape:
            return ((UIScreen.main.fixedCoordinateSpace.bounds.width - adType.size.height) * 0.55)
        case .RectangleAndPortrait:
            return ((UIScreen.main.fixedCoordinateSpace.bounds.height - adType.size.height) * 0.5)
        case .RectangleAndLandscape:
            return ((UIScreen.main.fixedCoordinateSpace.bounds.width - adType.size.height) * 0.2)
        case .InterstitialAndLandscape:
            return (UIScreen.main.fixedCoordinateSpace.bounds.width * 0.55)
        case .InterstitialAndPortrait:
            return (UIScreen.main.fixedCoordinateSpace.bounds.height * 0.65)
        }
    }
    
    static func getState(adType: SampleAdTypeEnum) -> AdViewContentState? {
        guard !adType.isInterstitial() else {
            return  UIDevice.current.orientation.isLandscape ? InterstitialAndLandscape : InterstitialAndPortrait
        }
        
        if (UIDevice.current.orientation.isLandscape) {
            return (adType == .Rectangle) ? RectangleAndLandscape : BannerAndLandscape
        } else {
            return (adType == .Rectangle) ? RectangleAndPortrait : BannerAndPortrait
        }
    }
}
