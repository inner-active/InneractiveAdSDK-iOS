//
//  MarketpalceAPI.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 21/03/2021.
//  Copyright © 2021 Fyber. All rights reserved.
//

import Foundation

class MarketplaceSDK: NSObject, SampleSDKProtocol {

    /* FMPSDKProtocol Properties */
    var presentingViewController: AdViewController!
    var delegate: SampleSDKProtocolDelegate?
    var requestAdType: SampleAdType?

    /* MarketplaceSDK Properties */
    var viewUnitController: IAViewUnitController?
    var fullscreenUnitController: IAFullscreenUnitController?
    var MRAIDContentController: IAMRAIDContentController?
    var videoContentController: IAVideoContentController?
    var adSpot: IAAdSpot?


    //MARK: - Inits

    required init(presentingViewController: AdViewController) {
        self.presentingViewController = presentingViewController
    }

    func initUnitAndContentController(with request:IAAdRequest? = nil) {
        videoContentController = IAVideoContentController.build({
                                                                    (builder: IAVideoContentControllerBuilder) in builder.videoContentDelegate = self})

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

        adSpot = IAAdSpot .build({ (builder:IAAdSpotBuilder) in
            if (request != nil) {
                builder.adRequest = request!
            }

            builder.addSupportedUnitController(self.fullscreenUnitController!)
            builder.addSupportedUnitController(self.viewUnitController!)
        })
    }

    //MARK: - Service

    func setupRequestAndControllers() {
        let request = IAAdRequest .build({ (builder:IAAdRequestBuilder) in
            builder.spotID = ClientRequestSettings.shared.getValue(of: .SpotId) ?? ""
            builder.debugger = IADebugger.build({ (IADebuggerBuilder) in /* ... */ })
            builder.keywords = "hell & brimstone + earthly/delight, diving,programming\new line"
            builder.timeout = 15
        })

        ClientRequestSettings.shared.updateRequestObject(with: request!)
        IASDKCore.sharedInstance().debugger = request?.debugger
        initUnitAndContentController(with: request!)
    }
    //MARK: - API

    func loadAd() {
        //TODO:May be cover for all use cases, need to test and check
        setupRequestAndControllers()
        weak var weakSelf = self
        adSpot?.fetchAd(completion: { (adSpot:IAAdSpot?, adModel:IAAdModel?, error:Error?)  in
            weakSelf?.requestTrackingPermissionsIfNeeded()
            weakSelf?.renderAd(with: adSpot, model: adModel, error: error)
            adSpot?.setAdRefreshCompletion({ (adSpot:IAAdSpot?, adModel:IAAdModel?, error:Error?) in
                weakSelf?.renderAd(with: adSpot, model: adModel, error: error)
            })
        })
    }

   func showInterstitial() {
        DispatchQueue.main.async { [weak self] in
            Console.shared.add(message: "<Fyber> Marketplace SDK will show fullscreen ad.")
            self?.fullscreenUnitController?.showAd(animated: true, completion:nil)
        }
    }

    //MARK: - Service

    func renderAd(with spot:IAAdSpot!, model:IAAdModel!, error:Error!) {
        if let error = error  {
            Console.shared.add(message: "<Fyber> ad failed with error: \(error.localizedDescription)")
            delegate?.adFailedToLoad(with: error.localizedDescription)
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if (spot.activeUnitController == self.viewUnitController) {
                self.viewUnitController?.showAd(inParentView:self.presentingViewController.adView!)

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

        ATTrackingManager.requestTrackingAuthorization { (status:ATTrackingManager.AuthorizationStatus) in
            Console.shared.add(message: "<Fyber> Current tracking status is \(status.rawValue)")
            if (status.rawValue == 3) {
                Console.shared.add(message: "<Fyber> IDFA is authorized.")
            }
        }
    }
}
