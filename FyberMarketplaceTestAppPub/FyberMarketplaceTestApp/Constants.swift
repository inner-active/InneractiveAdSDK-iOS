//
//  File.swift
//  FyberMarketplaceTestApp
//
//  Created by Or Avraham on 15/05/2022.
//  Copyright © 2022 Inneractive. All rights reserved.
//

import Foundation

struct Constants {
    
    struct SDKSettings {
        static let k_production = "wv.inner-active"
        static let defaultPort = "4321"
        
        static let gdprArray = ["Unknown", "Denied", "Given"]
        static let lgpdArray = ["Unknown", "Denied", "Given"]
        static let serverArray = ["wv.inner-active", "ia-cert"]
        static let ConfigurationOn = "Manual"
        static let ConfigurationArray = ["Off", ConfigurationOn]
    }
}
