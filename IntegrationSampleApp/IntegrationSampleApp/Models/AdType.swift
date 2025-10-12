////
//  AdType.swift
//  SampleApp
//
//  Created by DT on 18/09/2025.
//  Copyright © 2025 DT. All rights reserved.
//

import Foundation

enum AdType {
    case display(Display)
    case fullscreen(Fullscreen)
    case native

    enum Fullscreen {
        case interstitial
        case rewarded
    }
    
    enum Display {
        case banner
        case mrec
    }
}
    
extension AdType {
    var size: CGSize? {
        switch self {
        case .display(.banner): CGSize(width: 320, height: 50)
        case .display(.mrec): CGSize(width: 300, height: 250)
        default: nil
        }
    }
}

extension AdType {
    // Predefine spots
    var spotId: String {
        switch self {
        case .display(.banner): "150942"
        case .display(.mrec): "150943"
        case .fullscreen(.interstitial): "150946"
        case .fullscreen(.rewarded): "150949"
        case .native: "1783411"
        }
    }
}


