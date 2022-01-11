//
//  File.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 07/11/2021.
//  Copyright © 2021 Fyber. All rights reserved.
//

import Foundation

public extension UITableViewController {
    func adjustForDarkMode() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                tableView.backgroundColor = .black
            }
        }
    }
}
