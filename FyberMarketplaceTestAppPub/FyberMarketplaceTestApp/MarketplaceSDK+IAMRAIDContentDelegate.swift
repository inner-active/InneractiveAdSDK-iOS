//
//  FYBMarketplace+IAMRAIDContentDelegate.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 29/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation



// MARK: - IAMRAIDContentDelegate
extension MarketplaceSDK: IAMRAIDContentDelegate {

    func iamraidContentController(_ contentController: IAMRAIDContentController?, mraidAdDidResizeToFrame frame: CGRect) {
        Console.shared.add(message: "MRAIDAdWillResizeToFrame")

        DispatchQueue.main.async {
            self.delegate?.adDidResize(to: frame)
        }
    }

    func iamraidContentController(_ contentController: IAMRAIDContentController?, mraidAdWillResizeToFrame frame: CGRect){
        Console.shared.add(message: "MRAIDAdDidResizeToFrame")
    }

    func iamraidContentController(_ contentController: IAMRAIDContentController?, mraidAdWillExpandToFrame frame: CGRect){
        Console.shared.add(message: "MRAIDAdWillExpandToFrame")
    }

    func iamraidContentController(_ contentController: IAMRAIDContentController?, mraidAdDidExpandToFrame frame: CGRect) {
        Console.shared.add(message: "MRAIDAdDidExpandToFrame")
    }

    func iamraidContentControllerMRAIDAdWillCollapse(_ contentController: IAMRAIDContentController?) {
        Console.shared.add(message: "IAMRAIDContentControllerMRAIDAdWillCollapse")
    }

    func iamraidContentControllerMRAIDAdDidCollapse(_ contentController: IAMRAIDContentController?) {
        Console.shared.add(message: "IAMRAIDContentControllerMRAIDAdDidCollapse")
        
        guard let adView = self.viewUnitController?.adView else { return }
        DispatchQueue.main.async {
            self.delegate?.adDidResize(to: adView.frame)
        }
    }

    func iamraidContentController(_ contentController: IAMRAIDContentController?, videoInterruptedWithError error: Error){
        Console.shared.add(message: "IAMRAIDContentController:videoInterruptedWithError: \(error)", messageType: .error)
    }
}
