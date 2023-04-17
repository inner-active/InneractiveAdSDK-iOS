//
//  MarketpalceAPI.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 21/03/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation
import IASDKCore

class MarketplaceSDK: NSObject, SampleSDKProtocol {

    /* FMPSDKProtocol Properties */
    var presentingViewController: AdViewController!
    var delegate: SampleSDKProtocolDelegate?
    var requestAdType: SampleAdTypeEnum?

    /* MarketplaceSDK Properties */
    var viewUnitController: IAViewUnitController?
    var fullscreenUnitController: IAFullscreenUnitController?
    var MRAIDContentController: IAMRAIDContentController?
    var videoContentController: IAVideoContentController?
    var adSpot: IAAdSpot?


    // MARK: - Inits

    required init(presentingViewController: AdViewController) {
        self.presentingViewController = presentingViewController
    }

    func initUnitAndContentController(with request: IAAdRequest? = nil) {
        videoContentController = IAVideoContentController.build({(builder: IAVideoContentControllerBuilder) in builder.videoContentDelegate = self})
        
        MRAIDContentController = IAMRAIDContentController.build({ (builder: IAMRAIDContentControllerBuilder) in
            builder.mraidContentDelegate = self
        })
        
        viewUnitController = IAViewUnitController.build({ (builder: IAViewUnitControllerBuilder) in
            builder.unitDelegate = self
            
            builder.addSupportedContentController(self.MRAIDContentController!)
        })
        
        fullscreenUnitController = IAFullscreenUnitController.build({ (builder: IAFullscreenUnitControllerBuilder) in
            builder.unitDelegate = self
            
            builder.addSupportedContentController(self.MRAIDContentController!)
            builder.addSupportedContentController(self.videoContentController!)
        })
        
        adSpot = IAAdSpot .build({ (builder: IAAdSpotBuilder) in
            if request != nil {
                builder.adRequest = request!
            }
            
            builder.addSupportedUnitController(self.fullscreenUnitController!)
            builder.addSupportedUnitController(self.viewUnitController!)
        })
    }

    // MARK: - Service

    func setupRequestAndControllers() {
        IASDKCore.sharedInstance().mediationType = nil
        IASDKCore.sharedInstance().keywords = "hell & brimstone + earthly/delight, diving,programming\new line"
        
        if let request = IAAdRequest.build({ (builder: IAAdRequestBuilder) in
            builder.spotID = ClientRequestSettings.shared.getValue(of: .spotId) ?? ""
            builder.debugger = IADebugger.build({ (_) in })
            builder.timeout = 15
        }) {
            ClientRequestSettings.shared.updateRequestObject(with: request)
            IASDKCore.sharedInstance().debugger = request.debugger
            initUnitAndContentController(with: request)
        } else {
            Console.shared.add(message: "IAAdRequest is nil. Will not continue loading ad process.")
            delegate?.adFailedToLoad(with: "IAAdRequest is nil.")
            requestTrackingPermissionsIfNeeded()
        }
    }
    // MARK: - API

    func loadAd() {
        setupRequestAndControllers()
        weak var weakSelf = self
        adSpot?.fetchAd(completion: { (adSpot: IAAdSpot?, adModel: IAAdModel?, error: Error?)  in
            weakSelf?.requestTrackingPermissionsIfNeeded()
            weakSelf?.renderAd(with: adSpot, model: adModel, error: error)
            adSpot?.setAdRefreshCompletion({ (adSpot: IAAdSpot?, adModel: IAAdModel?, error: Error?) in
                weakSelf?.renderAd(with: adSpot, model: adModel, error: error)
            })
        })
    }
    
    func showInterstitial() {
        DispatchQueue.main.async { [weak self] in
            Console.shared.add(message: "will show fullscreen ad")
            self?.fullscreenUnitController?.showAd(animated: true, completion: nil)
        }
    }
    
    func disposeSDKInstance() {
        // dispose what is needed;
    }
    
    static func showMediationDebugger() {}

    // MARK: - Service

    func renderAd(with spot: IAAdSpot!, model: IAAdModel!, error: Error!) {
        if error != nil || spot == nil {
            let description = error?.localizedDescription ?? "empty spot"
            
            Console.shared.add(message: "ad failed with error: \(description)")
            delegate?.adFailedToLoad(with: description)
            
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if spot.activeUnitController == self.viewUnitController {
                self.viewUnitController?.showAd(inParentView: self.presentingViewController.adView!)

                guard let adView = self.viewUnitController?.adView else { return }

                self.presentingViewController.addConstraint(for: adView)

                self.delegate?.adDidLoad(with: self.requestAdType!)
                adView.backgroundColor = UIColor.black
                adView.translatesAutoresizingMaskIntoConstraints = false

            } else {
                self.delegate?.adDidLoad(with: self.requestAdType!)
            }
        }

        guard let videoContentController = spot.activeUnitController?.activeContentController as? IAVideoContentController else { return }
        videoContentController.videoContentDelegate = self
    }

    @objc func requestTrackingPermissionsIfNeeded() {
        guard #available (iOS 14, *) else { return }
        
        let statusExplanationMap = [0: "not determined", 1: "restricted", 2: "denied", 3: "authorized"]

        ATTrackingManager.requestTrackingAuthorization { (status: ATTrackingManager.AuthorizationStatus) in
            Console.shared.add(message: "current tracking status is \(statusExplanationMap[Int(status.rawValue)]!)")
            if status.rawValue == 3 {
                Console.shared.add(message: "IDFA is authorized")
            }
        }
    }
}
