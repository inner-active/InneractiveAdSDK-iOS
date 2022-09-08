//
//  AppDelegate.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 07/02/2021.
//  Copyright © 2021 Fyber. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , IAGlobalAdDelegate {
    var window: UIWindow?
    var originalRootVC: UIViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let kAppIDForTest = "102960"
        
        IALogger.setLogLevel(.verbose)
        IADebugger.adReportingEnabled = true
        
        
        ClientRequestSettings.shared.appId = kAppIDForTest
        IASDKCore.sharedInstance().globalAdDelegate = self
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SaveAdsViewController = storyboard.instantiateViewController(withIdentifier: "SaveAdsViewController") as! SaveAdsViewController
        let navigationController = UINavigationController(rootViewController: SaveAdsViewController)
        self.window?.rootViewController = navigationController
        return true
    }
    
    //MARK: - Service
    
    //MARK: - inits
    func topViewController() -> UIViewController {
        var topVC: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
        
        if topVC is UINavigationController {
            let navigationVC: UINavigationController = topVC as! UINavigationController
            topVC = navigationVC.topViewController!
        }
        while (topVC.presentingViewController != nil) {
            topVC = topVC.presentedViewController!
        }
        return topVC
    }
    
    //MARK: - IAGlobalAdDelegate
    func adDidShow(with impressionData: IAImpressionData, with adRequest: IAAdRequest) {
        let impMessage = "\n\nAd did show with impression data \ndemandSourceName: \(impressionData.demandSourceName ?? "")\ncountry: \(impressionData.country ?? "")\nsessionID: \(impressionData.sessionID ?? "")\nadvertiserDomain: \(impressionData.advertiserDomain ?? "")\ncreativeID: \(impressionData.creativeID ?? "")\ncampaignID: \(impressionData.campaignID ?? "")\npricing value: \(impressionData.pricingValue ?? NSNumber.init(value: 0))\npricingCurrency: \(impressionData.pricingCurrency ?? "")\nduration: \(impressionData.duration ?? NSNumber.init(value: 0))\nisSkippable: \(impressionData.isSkippable ?"YES":"NO")\nspotID: \(adRequest.spotID)\nunitID: \(adRequest.unitID ?? "")\n"
        
        Console.shared.add(message: impMessage)
    }
}
