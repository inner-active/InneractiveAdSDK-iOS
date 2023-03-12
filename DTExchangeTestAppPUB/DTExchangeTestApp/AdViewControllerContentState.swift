//
//  AdViewContentState.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 05/01/2022.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

protocol AdViewContentStateDelegate: AnyObject {
    func updateAdViewConstraintForAdView(with constant: CGFloat)
    func updateAdViewConstraintForAdInterstitialView(with constant: CGFloat)
}

class AdViewControllerContentState {
    let adType: SampleAdTypeEnum
    weak var delegate: AdViewContentStateDelegate?
    
    // MARK: - Init
    init(with adType: SampleAdTypeEnum) {
        self.adType = adType
    }
    
    // MARK: - OrientationDidChangeNotification
    @objc func adjustLoadAdTopConstraint() {
        let const = AdViewContentState.getState(adType: adType)!.getTopConstraint(from: adType)
        
        if adType.isInterstitial() {
            delegate?.updateAdViewConstraintForAdInterstitialView(with: const)
        } else {
            delegate?.updateAdViewConstraintForAdView(with: const)
        }
    }
    
    // MARK: - Deinit
    deinit {
        Console.shared.add(message: "\(String(describing: self)) deinit")
    }
}
