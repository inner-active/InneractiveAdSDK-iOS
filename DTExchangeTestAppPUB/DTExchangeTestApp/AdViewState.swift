//
//  AdViewState.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 01/02/2022.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

enum AdViewContentState {
    case bannerAndPortrait
    case bannerAndLandscape
    case rectangleAndPortrait
    case rectangleAndLandscape
    case interstitialAndLandscape
    case interstitialAndPortrait
    
    func getTopConstraint(from adType: SampleAdTypeEnum) -> CGFloat {
        switch self {
        case .bannerAndPortrait: // Use percentages to support different screen sizes
            return ((UIScreen.main.fixedCoordinateSpace.bounds.height - adType.size.height) * 0.6)
        case .bannerAndLandscape:
            return ((UIScreen.main.fixedCoordinateSpace.bounds.width - adType.size.height) * 0.55)
        case .rectangleAndPortrait:
            return ((UIScreen.main.fixedCoordinateSpace.bounds.height - adType.size.height) * 0.5)
        case .rectangleAndLandscape:
            return ((UIScreen.main.fixedCoordinateSpace.bounds.width - adType.size.height) * 0.2)
        case .interstitialAndLandscape:
            return (UIScreen.main.fixedCoordinateSpace.bounds.width * 0.55)
        case .interstitialAndPortrait:
            return (UIScreen.main.fixedCoordinateSpace.bounds.height * 0.65)
        }
    }
    
    static func getState(adType: SampleAdTypeEnum) -> AdViewContentState? {
        var isLandscape = UIDevice.current.orientation.isLandscape
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            isLandscape = UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight
        }
        
        guard !adType.isInterstitial() else {
            return  isLandscape ? interstitialAndLandscape : interstitialAndPortrait
        }
        
        if isLandscape {
            return (adType == .rectangle) ? rectangleAndLandscape : bannerAndLandscape
        } else {
            return (adType == .rectangle) ? rectangleAndPortrait : bannerAndPortrait
        }
    }
}
