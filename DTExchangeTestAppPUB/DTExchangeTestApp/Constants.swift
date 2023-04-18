//
//  File.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 15/05/2022.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

struct Constants {
    
    struct SDKSettings {
        static let kProduction = "wv.inner-active"
        static let defaultPort = "4321"
        
        static let gdprArray = ["Unknown", "Denied", "Given"]
        static let lgpdArray = ["Unknown", "Denied", "Given"]
        static let coppaArray = ["Unknown", "Denied", "Given"]
        static let serverArray = ["wv.inner-active", "ia-cert"]
        static let configurationOn = "Manual"
        static let configurationArray = ["Off", configurationOn]
    }
}
