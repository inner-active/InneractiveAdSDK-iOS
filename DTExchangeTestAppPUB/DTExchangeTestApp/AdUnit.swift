//
//  AdUnit.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 24/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

enum AdUnitSourceEnum: String, Codable {
    case mock = "Mock"
    case production = "Production"
}

/**
 *  @brief Represents Mock of ad unit.
 */
public class AdUnit: Codable, Equatable {
    static let defaultPortal = "4321"

    let id: String? // mock Id
    let name: String?
    let format: SampleAdTypeEnum
    let source: AdUnitSourceEnum
    
    lazy private(set) var spotId: String! = format.defaultSpotId
    lazy private(set) var portal: String? = AdUnit.defaultPortal
    
    convenience init(id: String, name: String, format: SampleAdTypeEnum, source: AdUnitSourceEnum) {
        self.init(id: id, name: name, format: format, source: source, spotid: format.defaultSpotId)
    }
    
    init(id: String?, name: String?, format: SampleAdTypeEnum, source: AdUnitSourceEnum, spotid: String, portal: String? = defaultPortal) {
        self.id = id
        self.name = name
        self.format = format
        self.source = source
        self.spotId = spotid
        self.portal = portal
    }
    
    public static func == (lhs: AdUnit, rhs: AdUnit) -> Bool {
        lhs.id == rhs.id && lhs.portal == rhs.portal && lhs.format == rhs.format
    }
}
