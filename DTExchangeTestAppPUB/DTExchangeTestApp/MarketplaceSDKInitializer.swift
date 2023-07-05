//
//  MarketplaceSDKInitializer.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 10/05/2022.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

extension MarketplaceSDK {
    static func initSDKCore(with appId: String) {
        IASDKCore.sharedInstance()?.initWithAppID(appId, completionBlock: { (success: Bool, error: Error?) in
            if success {
                let version = IASDKCore.sharedInstance().version() ?? ""
                Console.shared.add(message: "DTX SDK initialised: \(version)")
                setMetaData()
                setUserData()
            } else {
                Console.shared.add(message: "DTX SDK init failed: \(error.debugDescription)", messageType: .error)
            }
        }, completionQueue: DispatchQueue(label: "appDelegate queue"))
    }
    
    static fileprivate func setMetaData() {
        IASDKCore.sharedInstance().keywords = "tango, music"
    }
    
    static fileprivate func setUserData() {
        let userData = IAUserData.build { (builder: IAUserDataBuilder) in
            builder.age = 34
            builder.gender = IAUserGenderType.female
            builder.zipCode = "90210"
        }
        
        IASDKCore.sharedInstance().userData = userData
    }
}
