//
//  MultiValuesTableViewCell.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 28/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import UIKit

class MultiValuesCustomCell: UITableViewCell {
    static let identifier = "MultiValuesCustomCell"
    
    var delegate:ClientRequestSettingsDelegate!
    var options: [String]!
    var field:SampleSetting!
    @IBOutlet var title: UILabel!
    @IBOutlet var value: UILabel!
    
    var selectedRow:IndexPath! {
        didSet{
            delegate.valueDidChange(for: field, with: options[selectedRow.row])
        }
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static func configure(with field:SampleSetting, table:UITableView, indexPath:IndexPath, options:[String], delegate: ClientRequestSettingsDelegate) -> MultiValuesCustomCell {
        let multiValueCell = table.dequeueReusableCell(withIdentifier: MultiValuesCustomCell.identifier, for: indexPath) as! MultiValuesCustomCell
        
        multiValueCell.delegate = delegate
        multiValueCell.field = field
        multiValueCell.options = options
        multiValueCell.title.text = field.rawValue
        multiValueCell.selectedRow = IndexPath(row: multiValueCell.options.firstIndex(of: ClientRequestSettings.shared.getValue(of: field)!)!, section: 0) // need to initialize after _field!
        multiValueCell.value.text = multiValueCell.options[multiValueCell.selectedRow!.row]
        multiValueCell.value.textColor = .lightGray
        multiValueCell.accessoryType = .disclosureIndicator
        multiValueCell.selectionStyle = .default
        
        return multiValueCell
    }
}
