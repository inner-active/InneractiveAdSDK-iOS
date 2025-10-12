////
//  AdSource.swift
//  SampleApp
//
//  Created by DT on 18/09/2025.
//  Copyright © 2025 DT. All rights reserved.
//


import Foundation

enum AdSource {
    case production
    case mock(Mock)
    
    var mock: Mock? {
        switch self {
        case .mock(let mock): mock
        case .production: nil
        }
    }
}

struct Mock {
    private(set) var name: String = ""
    private(set) var portal: String = ""
    
    init(name: String, portal: String) {
        self.name = name
        self.portal = portal
    }
    
    init(with adType: AdType) {
        self.name = mockName(for: adType)
        self.portal = portal(for: adType)
    }
    
    // Predefine mocks
    private func mockName(for adType: AdType) -> String {
        switch adType {
        case .display(.banner): "mraidresize" //"bannerResponseForCI"
        case .display(.mrec): "rectangleforci"
        case .fullscreen(.interstitial): "7714"
        case .fullscreen(.rewarded): "7714"
        case .native: ""
        }
    }
    
    // Predefine portals
    private func portal(for adType: AdType) -> String {
        switch adType {
        case .display(.banner): "4321"
        case .display(.mrec): "5430"
        case .fullscreen(.interstitial): "4321"
        case .fullscreen(.rewarded): "4321"
        case .native: ""
        }
    }

}
