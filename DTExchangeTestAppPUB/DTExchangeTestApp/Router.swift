//
//  AdsViewRouterLogic.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 02/05/2022.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

@objc protocol Router: Route {
    func routeToAdView(segue: UIStoryboardSegue?, sender: Any?)
    func routeToFeedTableVC(segue: UIStoryboardSegue?, sender: Any?)
    func routeToScanner(segue: UIStoryboardSegue?, sender: Any?)
    func routeToMultiValue(segue: UIStoryboardSegue?, sender: Any?)
    func routeToshowNewAdUnitSegue(segue: UIStoryboardSegue?, sender: Any?)
}
