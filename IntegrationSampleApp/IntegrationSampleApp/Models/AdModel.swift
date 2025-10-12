////
//  AdModel.swift
//  SampleApp
//
//  Created by DT on 18/09/2025.
//  Copyright © 2025 DT. All rights reserved.
//

import SwiftUI
import IASDKCore

final class AdModel: NSObject, ObservableObject {
    @Published private(set) var adLoaded: Bool = false
    @Published private(set) var adLoading: Bool = false
    @Published private(set) var adSize: CGSize
    
    private var viewUnitController: IAViewUnitController?
    private var mraidContentController: IAMRAIDContentController?
    private var videoContentController: IAVideoContentController?
    private var fullscreenUnitController: IAFullscreenUnitController?
    private var adSpot: IAAdSpot?
    
    let adType: AdType
    
    init(_ adType: AdType) {
        self.adType = adType
        self.adSize = adType.size ?? .zero
    }

    private func setup(with request: IAAdRequest) {
        
        guard
            let videoContentController = IAVideoContentController.build ({ (builder: IAVideoContentControllerBuilder) in builder.videoContentDelegate = self
                }),
            let mraidContentController = IAMRAIDContentController.build ({ (builder: IAMRAIDContentControllerBuilder) in
                builder.mraidContentDelegate = self
            }),
            let fullscreenUnitController = IAFullscreenUnitController.build({ (builder: IAFullscreenUnitControllerBuilder) in
                builder.unitDelegate = self
                builder.addSupportedContentController(videoContentController)
                builder.addSupportedContentController(mraidContentController)
            }),
            let viewUnitController = IAViewUnitController.build( { (builder: IAViewUnitControllerBuilder) in
                builder.unitDelegate = self
                builder.addSupportedContentController(mraidContentController)
            }),
            let adSpot = IAAdSpot.build({ (builder: IAAdSpotBuilder) in
                builder.adRequest = request
                
                builder.addSupportedUnitController(fullscreenUnitController)
                builder.addSupportedUnitController(viewUnitController)
            })
        else {
            print("Ad controllers creation failed.")
            return
        }

        self.videoContentController = videoContentController
        self.mraidContentController = mraidContentController
        self.fullscreenUnitController = fullscreenUnitController
        self.viewUnitController = viewUnitController
        self.adSpot = adSpot
    }
    
    func load(
        adSource: AdSource = .production,
        timeout: TimeInterval = 15
    ) {
        
        guard let adRequest = IAAdRequest.build( { adRequest in
            adRequest.spotID = self.adType.spotId
            adRequest.timeout = timeout

            if let mock = adSource.mock {
                adRequest.debugger = IADebugger.build { debugger in
                    debugger.mockResponsePath =  mock.name
                    debugger.database =  mock.portal
                }
            }
        }) else {
            print("Bad request.")
            return
        }

        setup(with: adRequest)
        
        adLoaded = false
        adLoading = true
        adSize = adType.size ?? .zero
        
        adSpot?.fetchAd { [weak self] spot, model, error in
            guard let self else { return }
            
            self.adLoading = false
            
            if let error {
                print("Error: \(error)")
            } else {
                self.adLoaded = true
            }
        }
    }
    
    func show(animated: Bool = true) {
        self.fullscreenUnitController?.showAd(animated: animated) { [weak self] in
            guard let self else { return }
            self.adLoaded = false
        }
    }
    
    func show(in view: UIView) {
        self.viewUnitController?.showAd(inParentView: view)
    }
}

// MARK:: IAUnitDelegate
extension AdModel: IAUnitDelegate {
    func iaParentViewController(for unitController: IAUnitController?) -> UIViewController {
        UIApplication.shared.topMostViewController
    }
    
    func iaAdDidReceiveClick(_ unitController: IAUnitController?) {
        print("\(#function)")
    }
    
    func iaAdWillLogImpression(_ unitController: IAUnitController?) {
        print("\(#function)")
    }
    
    func iaAdDidReward(_ unitController: IAUnitController?) {
        print("\(#function)")
    }
    
    func iaUnitControllerWillPresentFullscreen(_ unitController: IAUnitController?) {
        print("\(#function)")
    }
    
    func iaUnitControllerDidPresentFullscreen(_ unitController: IAUnitController?) {
        print("\(#function)")
    }
    
    func iaUnitControllerWillDismissFullscreen(_ unitController: IAUnitController?) {
        print("\(#function)")
    }

    func iaUnitControllerDidDismissFullscreen(_ unitController: IAUnitController?) {
        print("\(#function)")
    }
    
    func iaUnitControllerWillOpenExternalApp(_ unitController: IAUnitController?) {
        print("\(#function)")
    }
    
    func iaAdDidExpire(_ unitController: IAUnitController?) {
        print("\(#function)")
    }
}

// MARK:: IAVideoContentDelegate
extension AdModel: IAVideoContentDelegate {
    func iaVideoCompleted(_ contentController: IAVideoContentController?) {
        print("\(#function)")
    }
    
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoInterruptedWithError error: Error) {
        print("\(#function): \(error) ")
    }
    
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoDurationUpdated videoDuration: TimeInterval) {
        print("\(#function): \(videoDuration)")
    }
    
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoProgressUpdatedWithCurrentTime currentTime: TimeInterval, totalTime: TimeInterval) {
    }
}

// MARK:: IAMRAIDContentDelegate
extension AdModel: IAMRAIDContentDelegate {
    func iamraidContentController(_ contentController: IAMRAIDContentController?, mraidAdWillResizeToFrame frame: CGRect) {
        print("\(#function): \(frame)")
    }
    
    func iamraidContentController(_ contentController: IAMRAIDContentController?, mraidAdDidResizeToFrame frame: CGRect) {
        print("\(#function): \(frame)")
        self.adSize = CGSize(width: frame.width, height: frame.height)
    }


    func iamraidContentController(_ contentController: IAMRAIDContentController?, mraidAdWillExpandToFrame frame: CGRect) {
        print("\(#function): \(frame)")
    }

    func iamraidContentController(_ contentController: IAMRAIDContentController?, mraidAdDidExpandToFrame frame: CGRect) {
        print("\(#function): \(frame)")
    }

    func iamraidContentControllerMRAIDAdWillCollapse(_ contentController: IAMRAIDContentController?) {
        print("\(#function)")

    }

    func iamraidContentControllerMRAIDAdDidCollapse(_ contentController: IAMRAIDContentController?) {
        print("\(#function)")
        self.adSize = adType.size ?? .zero
    }

    func iamraidContentController(_ contentController: IAMRAIDContentController?, videoInterruptedWithError error: Error) {
        print("\(#function): \(error)")
    }
}
