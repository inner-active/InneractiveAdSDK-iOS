//
//  MenuTableViewCell.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 23/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit

class AdUnitCustomCell: UITableViewCell {
    static let identifier = "MenuTableViewCell"
    var model: AdUnit?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
        selectionStyle = .default
    }
    
    func configure(with model: AdUnit, indexPath: IndexPath) {
        self.model = model
        textLabel!.text = model.name ?? "#\(model.portal!)"
        detailTextLabel?.text = model.format.rawValue
        var acLabel = ""
        switch model.format {
        case .banner:
            if model.id == "bannerResponseForCI" {
                acLabel = "Request Banner Ad"
            }
        case .rectangle:
            if model.id == "rectangleforci" {
                acLabel = "Request MREC Ad"
            }
        case .interstitial:
            if model.id == "7715" {
                acLabel = "Request Video Interstitial Ad"
            } else if model.id == "interstitialadresponseforcilandscape" {
                acLabel = "Request Display Interstitial Ad"
            }
        case .rewarded:
            if model.id == "7715" {
                acLabel = "Request Rewarded Ad"
            }
        default:
            acLabel = ""
        }
        accessibilityLabel = acLabel
    }
}
