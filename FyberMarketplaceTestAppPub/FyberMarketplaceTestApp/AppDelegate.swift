//
//  AppDelegate.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 07/02/2021.
//  Copyright © 2021 Fyber. All rights reserved.
//

import Foundation

class AppDelegate: UIResponder, UIApplicationDelegate , IAGlobalAdDelegate{
    var window: UIWindow?
    var originalRootVC: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let kAppIDForTest = "102960"

        IALogger.setLogLevel(.verbose)
        IADebugger.adReportingEnabled = true


        ClientRequestSettings.shared.appId = kAppIDForTest


        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sampleAdsViewController = storyboard.instantiateViewController(withIdentifier: "SampleAdsViewController") as! SampleAdsViewController
        let navigationController = UINavigationController(rootViewController: sampleAdsViewController)
        self.window?.rootViewController = navigationController

        return true
    }

    //MARK: - Service


    //MARK: - inits

    func initSDKCore(with appId:String) {
        IASDKCore.sharedInstance()?.initWithAppID(appId, completionBlock: { (success:Bool, error:Error?) in
            // init is mandatory
            if success {
                let version = IASDKCore.sharedInstance().version() ?? ""

                Console.shared.add(message: "Fyber Marketplace SDK has been initialised, version: \(version)")
                IASDKCore.sharedInstance().globalAdDelegate = self
                IASDKCore.sharedInstance().ccpaString = "1YYY"

                let userData = IAUserData.build { (builder:IAUserDataBuilder) in
                    builder.age = 34
                    builder.gender = IAUserGenderType.female
                    builder.zipCode = "90210"
                }

                IASDKCore.sharedInstance().userData = userData
                IASDKCore.sharedInstance().keywords = "tango, music"
                IASDKCore.sharedInstance().location = CLLocation(latitude:50.45, longitude:30.52)
                IASDKCore.sharedInstance().muteAudio = true
            } else {
                Console.shared.add(message: "Fyber Marketplace SDK init has failed: \(error.debugDescription)", messageType: .error)
            }
        }, completionQueue:DispatchQueue(label: "appDelegate queue")) //  serial by default
    }

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
