//
//  TextFieldTableViewCell.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 28/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit

class TextFieldCustomCell: UITableViewCell {
    static let identifier = "TextFieldCustomCell"
    
    weak var delegate: ClientRequestSettingsDelegate!
    var field: SampleSettingsEnum!
    @IBOutlet var title: UILabel!
    @IBOutlet var userInput: UITextField!
   
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static func configure (
        with field: SampleSettingsEnum,
        table: UITableView,
        indexPath: IndexPath,
        delegate: ClientRequestSettingsDelegate) -> TextFieldCustomCell {
            if let textFieldCell = table.dequeueReusableCell(
                withIdentifier: TextFieldCustomCell.identifier,
                for: indexPath) as? TextFieldCustomCell {
                textFieldCell.delegate = delegate
                textFieldCell.field = field
                textFieldCell.title.text = field.rawValue
                textFieldCell.userInput.delegate = textFieldCell
                textFieldCell.clipsToBounds = true
                guard let value = field.ClientSettingsValue, !value.isEmpty else {
                    textFieldCell.setDefaultValues(field: field)
                    return textFieldCell
                }
                
                textFieldCell.userInput.text = value
                
                return textFieldCell
            } else { return TextFieldCustomCell() }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        field = nil
        title.text = ""
        userInput.text = ""
    }
}

// MARK: - Service
private extension TextFieldCustomCell {
    private func setDefaultValues(field: SampleSettingsEnum) {
        if field == .mockName {
            userInput.placeholder = field.ClientSettingsValue == nil ? "Enter Mock Name" : field.ClientSettingsValue
        } else {
            userInput.placeholder = field.ClientSettingsValue == nil ?  "Click to override" : "Empty"
        }
    }
}

// MARK: - UITextFieldDelegate
extension TextFieldCustomCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let userInput = textField.text, userInput != field.ClientSettingsValue {
            delegate.valueDidChange(for: field, with: userInput)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.endEditing(true)
        return true
    }
}
