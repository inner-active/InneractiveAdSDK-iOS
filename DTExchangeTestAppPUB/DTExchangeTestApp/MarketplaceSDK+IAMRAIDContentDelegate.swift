//
//  FYBMarketplace+IAMRAIDContentDelegate.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 29/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

// MARK: - IAMRAIDContentDelegate

extension MarketplaceSDK: IAMRAIDContentDelegate {
    func iamraidContentController(_ contentController: IAMRAIDContentController?, mraidAdDidResizeToFrame frame: CGRect) {
        Console.shared.add(message: "IMRAIDAdWillResizeToFrame to (\(frame.width),\(frame.height))")
        DispatchQueue.main.async {
            self.delegate?.adDidResize(to: frame)
        }
    }

    func iamraidContentController(_ contentController: IAMRAIDContentController?, mraidAdWillResizeToFrame frame: CGRect) {
        Console.shared.add(message: "IMRAIDAdDidResizeToFrame to (\(frame.width),\(frame.height))")
    }

    func iamraidContentController(_ contentController: IAMRAIDContentController?, mraidAdWillExpandToFrame frame: CGRect) {
        Console.shared.add(message: "IMRAIDAdWillExpandToFrame to (\(frame.width),\(frame.height))")
    }

    func iamraidContentController(_ contentController: IAMRAIDContentController?, mraidAdDidExpandToFrame frame: CGRect) {
        Console.shared.add(message: "IMRAIDAdDidExpandToFrame to (\(frame.width),\(frame.height))")
    }

    func iamraidContentControllerMRAIDAdWillCollapse(_ contentController: IAMRAIDContentController?) {
        Console.shared.add(message: "IAMRAIDContentControllerMRAIDAdWillCollapse")
    }

    func iamraidContentControllerMRAIDAdDidCollapse(_ contentController: IAMRAIDContentController?) {
        Console.shared.add(message: "IAMRAIDContentControllerMRAIDAdDidCollapse")

        guard self.viewUnitController?.adView != nil else { return }
        DispatchQueue.main.async {
            self.delegate?.adDidResize(to: CGRect.init(origin: CGPoint.zero, size: self.requestAdType!.size))
        }
    }

    func iamraidContentController(_ contentController: IAMRAIDContentController?, videoInterruptedWithError error: Error) {
        Console.shared.add(message: "IAMRAIDContentController:videoInterruptedWithError: \(error)", messageType: .error)
    }
}
