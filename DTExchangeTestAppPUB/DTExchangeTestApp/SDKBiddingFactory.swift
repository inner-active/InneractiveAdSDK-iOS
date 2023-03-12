//
//  SDKBiddingFactory.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 05/09/2022.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

struct SDKBiddingFactory {
    static func getIAMediation(by name: String) -> IAMediation {
        switch name.lowercased() {
        case "max": return IAMediationMax()
        case "ironsource": return IAMediationIronSource()
        default: return IAMediationMax()
        }
    }
}
