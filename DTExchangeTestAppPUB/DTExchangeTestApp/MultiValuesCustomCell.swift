//
//  MultiValuesTableViewCell.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 28/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit

class MultiValuesCustomCell: UITableViewCell {
    static let identifier = "MultiValuesCustomCell"
    
    var delegate: ClientRequestSettingsDelegate!
    var options: [String]!
    var field: SampleSettingsEnum!
    @IBOutlet var title: UILabel!
    @IBOutlet var value: UILabel!
    
    var selectedRow: IndexPath! {
        didSet {
            delegate.valueDidChange(for: field, with: options[selectedRow.row])
        }
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static func configure(
        with field: SampleSettingsEnum,
        table: UITableView,
        indexPath: IndexPath,
        options: [String],
        delegate: ClientRequestSettingsDelegate) -> MultiValuesCustomCell {
        if let multiValueCell = table.dequeueReusableCell(
            withIdentifier: MultiValuesCustomCell.identifier,
            for: indexPath) as? MultiValuesCustomCell {
            let valueOfField = ClientRequestSettings.shared.getValue(of: field)
            let firstIndexOfField = options.firstIndex(of: valueOfField ?? "")
            let selectedIndexPath = IndexPath(row: firstIndexOfField ?? 0, section: 0)
            
            multiValueCell.delegate = delegate
            multiValueCell.field = field
            multiValueCell.options = options
            multiValueCell.title.text = field.rawValue
            multiValueCell.selectedRow = selectedIndexPath // need to initialize after _field!
            multiValueCell.value.text = multiValueCell.options[multiValueCell.selectedRow!.row]
            multiValueCell.value.textColor = .lightGray
            multiValueCell.accessoryType = .disclosureIndicator
            multiValueCell.selectionStyle = .default
            multiValueCell.clipsToBounds = true
            
            return multiValueCell
        } else { return MultiValuesCustomCell() }
    }
}
