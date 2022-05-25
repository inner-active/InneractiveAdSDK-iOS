//
//  AdViewRouter.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 14/04/2022.
//  Copyright © 2022 Fyber. All rights reserved.
//

import Foundation

protocol AdsViewRouterLogic {
    func routeToAdViewController(segue: UIStoryboardSegue?, sender: Any?)
}

class AdsViewRouter: AdsViewRouterLogic {
    weak var viewController: AdViewController?
    
    func routeToAdViewController(segue: UIStoryboardSegue?, sender: Any?) {
        if let segue = segue,
           let model = sender as? AdUnit,
           let controller = segue.destination as? AdViewController {
            
            controller.setup(with: MarketplaceSDK(presentingViewController: controller), adType: model.format, title: model.name)
            ClientRequestSettings.shared.removeUserDefaultsIfNeeded()
        }
    }
}
