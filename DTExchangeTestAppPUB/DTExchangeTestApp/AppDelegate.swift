//
//  AppDelegate.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 07/02/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit
import IASDKCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, IAGlobalAdDelegate {
    var window: UIWindow?
    var originalRootVC: UIViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let kAppIDForTest = "102960"
        
        DTXLogger.setLogLevel(DTXLogLevel.debug)
        IADebugger.adReportingEnabled = true
        
        
        ClientRequestSettings.shared.appId = kAppIDForTest
        IASDKCore.sharedInstance().globalAdDelegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable force_cast
        let saveAdsViewController = storyboard.instantiateViewController(withIdentifier: "SaveAdsViewController") as! SaveAdsViewController
        // swiftlint:enable force_cast
        let navigationController = UINavigationController(rootViewController: saveAdsViewController)
        self.window?.rootViewController = navigationController
        return true
    }
    
    // MARK: - Service
    
    // MARK: - inits
    
    func topViewController() -> UIViewController {
        var topVC: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
        
        if topVC is UINavigationController {
            if let navigationVC: UINavigationController = topVC as? UINavigationController {
                topVC = navigationVC.topViewController!
            }
        }
        while topVC.presentingViewController != nil {
            topVC = topVC.presentedViewController!
        }
        return topVC
    }
    
    // MARK: - IAGlobalAdDelegate
    func adDidShow(with impressionData: IAImpressionData, with adRequest: IAAdRequest) {
        let impMessage = """
ad did show with impression data:\n
demandSourceName: \(impressionData.demandSourceName ?? "")
country: \(impressionData.country ?? "")
sessionID: \(impressionData.sessionID ?? "")
advertiserDomain: \(impressionData.advertiserDomain ?? "")
creativeID: \(impressionData.creativeID ?? "")\ncampaignID: \(impressionData.campaignID ?? "")
pricing value: \(impressionData.pricingValue ?? NSNumber(0))
pricingCurrency: \(impressionData.pricingCurrency ?? "")
duration: \(impressionData.duration ?? NSNumber(0))
isSkippable: \(impressionData.isSkippable ?"YES":"NO")
spotID: \(adRequest.spotID)
unitID: \(adRequest.unitID ?? "")\n
"""
        Console.shared.add(message: impMessage)
    }
}
