//
//  FYBMarketplace+IAVideoContentDelegate.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 29/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation


//MARK: - IAVideoContentDelegate

extension MarketplaceSDK: IAVideoContentDelegate {
    func iaVideoCompleted(_ contentController: IAVideoContentController?) {
        Console.shared.add(message:"IAVideoCompleted")
    }
    
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoInterruptedWithError error: Error){
        Console.shared.add(message:"IAVideoInterruptedWithError: \(error.localizedDescription)", messageType: .error)
    }
    
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoDurationUpdated videoDuration: TimeInterval) {
        Console.shared.add(message:"IAVideoDurationUpdated")
    }
    
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoProgressUpdatedWithCurrentTime currentTime: TimeInterval, totalTime: TimeInterval) {
        Console.shared.add(message:"IAVideoProgressUpdatedWithCurrentTime: \(currentTime) totalTime: \(totalTime)")
    }
}
