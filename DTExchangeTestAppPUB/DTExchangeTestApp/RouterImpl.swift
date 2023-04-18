//
//  AdViewRouter.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 14/04/2022.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

@objc protocol Route {
    func route(with segue: UIStoryboardSegue, sender: Any?)
}

// MARK: - Route
class RouterImpl: NSObject, Route {
    func route(with segue: UIStoryboardSegue, sender: Any?) {
        guard let scene = segue.identifier else { return }
        
        let selector = NSSelectorFromString("routeTo\(scene)WithSegue:sender:")
        if self.responds(to: selector) {
            self.perform(selector, with: segue, with: sender)
        }
    }
}

// MARK: - Router
extension RouterImpl: Router {
    func routeToAdView(segue: UIStoryboardSegue?, sender: Any?) {
        if let segue = segue,
           let sender = sender,
           let model = sender as? AdUnit,
           let controller = segue.destination as? AdViewController {
            controller.setup(
                with: MarketplaceSDK(presentingViewController: controller),
                adType: model.format,
                title: model.name ?? ""
            )
            
            ClientRequestSettings.shared.updateClientRequest(with: model)
            ClientRequestSettings.shared.removeUserDefaultsIfNeeded()
        }
    }
    
    func routeToFeedTableVC(segue: UIStoryboardSegue?, sender: Any?) {
        if let sender = sender,
           let model = sender as? AdUnit {
            ClientRequestSettings.shared.updateClientRequest(with: model)
            ClientRequestSettings.shared.removeUserDefaultsIfNeeded()
        }
    }
    
    func routeToScanner(segue: UIStoryboardSegue?, sender: Any?) {
        if let segue = segue,
           let sender = sender,
           let delegate = sender as? ScannerViewControllerDelegate,
           let controller = segue.destination as? ScannerViewController {
            controller.setup(delegate: delegate)
        }
    }
    
    func routeToshowNewAdUnitSegue(segue: UIStoryboardSegue?, sender: Any?) {
        guard let segue = segue,
              let sender = sender as? AdUnit,
              let controller = segue.destination as? NewAdUnitController else { return }
        controller.configureToEdit(adUnit: sender)
    }
    
    func routeToMultiValue(segue: UIStoryboardSegue?, sender: Any?) {
        guard let segue = segue,
              let sender = sender,
              let controller = segue.destination as? MultiValueTableViewController,
              let multiValueCell = sender as? MultiValuesCustomCell else {
            return
        }
        controller.configure(with: multiValueCell)
    }
}
