//
//  MenuTableViewCell.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 23/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
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
    
    func configure(with model:AdUnit) {
        self.model = model
        textLabel!.text = model.name
    }
}
