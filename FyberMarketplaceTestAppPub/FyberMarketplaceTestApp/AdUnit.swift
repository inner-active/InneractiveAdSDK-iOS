//
//  AdUnit.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 24/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

enum AdUnitSource:String, Decodable, Encodable {
    case Mock = "Mock"
    case Production = "Production"
}

/**
 Represents Mock of ad unit.
 */
public class AdUnit : NSObject, Decodable, Encodable {
    
    internal let id: String
    
    internal let name: String
    
    internal let format: SampleAdType
    
    internal let source: AdUnitSource
    
    init(id:String,_ name:String,_ format: SampleAdType,_ source: AdUnitSource) {
        self.id = id
        self.name = name
        self.format = format
        self.source = source
    }
}
