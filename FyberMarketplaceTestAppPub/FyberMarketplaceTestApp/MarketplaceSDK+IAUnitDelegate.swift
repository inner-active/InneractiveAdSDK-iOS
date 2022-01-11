//
//  FYBMarketplace+IAUnitDelegate.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 29/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

//MARK: - IAUnitDelegate

extension MarketplaceSDK: IAUnitDelegate {
    func iaParentViewController(for unitController: IAUnitController?) -> UIViewController {
        return presentingViewController
    }
    
    func iaAdDidReceiveClick(_ unitController: IAUnitController?) {
        Console.shared.add(message:"IAAdDidReceiveClick")
    }
    
    func iaAdWillLogImpression(_ unitController: IAUnitController?) {
        Console.shared.add(message:"IAAdWillLogImpression")
    }
    
    func iaAdDidReward(_ unitController: IAUnitController?) {
        Console.shared.add(message:"IAAdDidReward")
    }
    
    func iaUnitControllerWillPresentFullscreen(_ unitController: IAUnitController?) {
        Console.shared.add(message:"IAUnitControllerDidPresentFullscreen")
    }
    
    func iaUnitControllerDidPresentFullscreen(_ unitController: IAUnitController?) {
        Console.shared.add(message:"IAUnitControllerDidPresentFullscreen")
    }
    
    func iaUnitControllerWillDismissFullscreen(_ unitController: IAUnitController?) {
        Console.shared.add(message:"IAUnitControllerWillDismissFullscreen")
    }

    func iaUnitControllerDidDismissFullscreen(_ unitController: IAUnitController?) {
        Console.shared.add(message:"IAUnitControllerDidDismissFullscreen")
    }
    
    func iaUnitControllerWillOpenExternalApp(_ unitController: IAUnitController?) {
        Console.shared.add(message:"IAUnitControllerWillOpenExternalApp")
    }
    
    func iaAdDidExpire(_ unitController: IAUnitController?) {
        Console.shared.add(message:"IAAdDidExpire")
    }
}
