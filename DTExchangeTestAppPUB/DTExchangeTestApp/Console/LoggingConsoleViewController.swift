//
//  LoggingConsoleViewController.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 09/11/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit

class LoggingConsoleViewController: ConsoleViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        updateMessages()
        Console.shared.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if Console.shared.messages.isEmpty {
            tipView.isHidden = false
        }
    }

    private func updateMessages() {
        let attributedText = NSMutableAttributedString()

        for message in Console.shared.messages {
            let attrString = attributedString(fromMessage: message)

            attributedText.append(attrString)
        }

        textView.attributedText = attributedText
    }

    private func attributedString(fromMessage message: Console.Message) -> NSAttributedString {
        let font = UIFont(name: "Menlo", size: 12.0)!
        let boldFont = UIFont(name: "Menlo-Bold", size: 12.0)!
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "HH:mm:ss.SSS"

        let date = dateFormatter.string(from: message.date)
   
        let attributedString = NSMutableAttributedString(string: "\(date) - \(message.text)\n", attributes: [
                .font: font,
                .foregroundColor: message.type.color
            ])
        
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont]
        let range = NSRange(location: 0, length: date.count)

        attributedString.addAttributes(boldFontAttribute, range: range)

        return attributedString
    }
    
}

// MARK: Console Delegate

extension LoggingConsoleViewController: ConsoleDelegate {
    
    func consoleDidAdd(message: Console.Message) {
        tipView.isHidden = true

        if let attributedText = textView.attributedText.mutableCopy() as? NSMutableAttributedString {
            let attrString = attributedString(fromMessage: message)
            
            attributedText.append(attrString)
            textView.attributedText = attributedText
            
            guard textView.contentSize.height > textView.bounds.height else { return }
            
            textView.setContentOffset(CGPoint(x: 0, y: textView.contentSize.height - textView.bounds.height), animated: true)
        }
    }
}
