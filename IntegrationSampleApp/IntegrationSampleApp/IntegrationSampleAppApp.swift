////
//  IntegrationSampleAppApp.swift
//  IntegrationSampleApp
//
//  Created by DT on 18/09/2025.
//  Copyright © 2025 DT. All rights reserved.
//

import SwiftUI
import IASDKCore

@main
struct IntegrationSampleAppApp: App {
    private var marketplaceSDK = MarketplaceSDK()
    
    init() {
        // Initialize the SDK right when the app starts
        marketplaceSDK.initSdk(with: "102960")
        
        // Set logs level
        // .debug - full logs
        // .off - no logs
        DTXLogger.setLogLevel(.off)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
