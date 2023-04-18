//
//  FYBMarketplace+IAUnitDelegate.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 29/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

// MARK: - IAUnitDelegate

extension MarketplaceSDK: IAUnitDelegate {
    func iaParentViewController(for unitController: IAUnitController?) -> UIViewController {
        return presentingViewController
    }
    
    func iaAdDidReceiveClick(_ unitController: IAUnitController?) {
        Console.shared.add(message: "ad event: click")
    }
    
    func iaAdWillLogImpression(_ unitController: IAUnitController?) {
        Console.shared.add(message: "ad event: impression")
    }
    
    func iaAdDidReward(_ unitController: IAUnitController?) {
        Console.shared.add(message: "ad event: rewarded")
    }
    
    func iaUnitControllerWillPresentFullscreen(_ unitController: IAUnitController?) {
        Console.shared.add(message: "ad flow: will present fullscreen")
    }
    
    func iaUnitControllerDidPresentFullscreen(_ unitController: IAUnitController?) {
        Console.shared.add(message: "ad flow: did present fullscreen")
    }
    
    func iaUnitControllerWillDismissFullscreen(_ unitController: IAUnitController?) {
        Console.shared.add(message: "ad flow: will dismiss fullscreen")
    }

    func iaUnitControllerDidDismissFullscreen(_ unitController: IAUnitController?) {
        Console.shared.add(message: "ad flow: did dismiss fulsscreen")
    }
    
    func iaUnitControllerWillOpenExternalApp(_ unitController: IAUnitController?) {
        Console.shared.add(message: "ad flow: will open external app")
    }
    
    func iaAdDidExpire(_ unitController: IAUnitController?) {
        Console.shared.add(message: "ad event: ad expired")
    }
}
