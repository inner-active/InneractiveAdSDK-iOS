//
//  MarketplaceSDKInitializer.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 10/05/2022.
//  Copyright © 2022 Fyber. All rights reserved.
//

import Foundation

extension MarketplaceSDK {
    static func initSDKCore(with appId:String) {
        IASDKCore.sharedInstance()?.initWithAppID(appId, completionBlock: { (success:Bool, error:Error?) in
            if success {
                let version = IASDKCore.sharedInstance().version() ?? ""
                Console.shared.add(message: "Fyber Marketplace SDK has been initialised, version: \(version)")
                setMetaData()
                setUserData()
            } else {
                Console.shared.add(message: "Fyber Marketplace SDK init has failed: \(error.debugDescription)", messageType: .error)
            }
        }, completionQueue:DispatchQueue(label: "appDelegate queue"))
    }
    
    static fileprivate func setMetaData() {
        IASDKCore.sharedInstance().keywords = "tango, music"
        IASDKCore.sharedInstance().location = CLLocation(latitude:50.45, longitude:30.52)
        IASDKCore.sharedInstance().muteAudio = true
    }
    
    static fileprivate func setUserData() {
        let userData = IAUserData.build { (builder:IAUserDataBuilder) in
            builder.age = 34
            builder.gender = IAUserGenderType.female
            builder.zipCode = "90210"
        }
        
        IASDKCore.sharedInstance().userData = userData
    }
}
