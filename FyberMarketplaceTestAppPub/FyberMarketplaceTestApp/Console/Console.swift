//
//  Console.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 09/11/2021.
//  Copyright © 2021 Fyber. All rights reserved.
//

import os.log
import UIKit

protocol ConsoleDelegate: AnyObject {
    func consoleDidAdd(message: Console.Message)
}

class Console {
    struct Message {
        enum Level {
            case debug
            case error

            var color: UIColor {
                switch self {
                case .debug:
                    return .black
                case .error:
                    return UIColor(red: 1.00, green: 0.13, blue: 0.40, alpha: 1.0)
                }
            }
        }

        let text: String
        let type: Level
        let date: Date
    }

    static var shared = Console()

    weak var delegate: ConsoleDelegate?

    private(set) var messages = [Message]()

    func add(message: String, messageType: Message.Level = .debug) {
        let consoleMessage = Message(text: message, type: messageType, date: Date())
        os_log("%{public}@", message)
        messages.append(consoleMessage)

        DispatchQueue.main.async {
            self.delegate?.consoleDidAdd(message: consoleMessage)
        }
    }
}
