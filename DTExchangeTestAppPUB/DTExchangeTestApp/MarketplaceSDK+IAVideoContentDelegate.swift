//
//  FYBMarketplace+IAVideoContentDelegate.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 29/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

// MARK: - IAVideoContentDelegate

extension MarketplaceSDK: IAVideoContentDelegate {
    func iaVideoCompleted(_ contentController: IAVideoContentController?) {
        Console.shared.add(message: "IAVideoCompleted")
    }
    
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoInterruptedWithError error: Error) {
        Console.shared.add(message: "IAVideoInterruptedWithError: \(error.localizedDescription)", messageType: .error)
        delegate?.adFailedToLoad(with: error.localizedDescription)
    }
    
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoDurationUpdated videoDuration: TimeInterval) {
        Console.shared.add(message: "IAVideoDurationUpdated")
    }
    
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoProgressUpdatedWithCurrentTime currentTime: TimeInterval, totalTime: TimeInterval) {}
}
