//
//  File.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 07/11/2021.
//  Copyright © 2021 Fyber. All rights reserved.
//

import Foundation

public extension UITableViewController {
    func adjustBackgroundColor() {
        if #available(iOS 13.0, *) {
            if ((self.traitCollection.userInterfaceStyle == .dark) &&  (tableView.backgroundColor != .black)) {
                tableView.backgroundColor = .black
            } else if ((self.traitCollection.userInterfaceStyle == .light) &&  (tableView.backgroundColor != .systemGray6)){
                tableView.backgroundColor = .systemGray6
            }
        }
    }
}
