////
//  NativeAdModel.swift
//  SampleApp
//
//  Created by DT on 18/09/2025.
//  Copyright © 2025 DT. All rights reserved.
//


import SwiftUI
import IASDKCore

final class NativeAdModel: NSObject, ObservableObject {
    @Published private(set) var title: String?
    @Published private(set) var adDescription: String?
    @Published private(set) var callToActionText: String?
    @Published private(set) var appIcon: UIView?
    @Published private(set) var mediaView: UIView?
    @Published private(set) var rating: String?
    @Published private(set) var advertiserName: String?
    @Published private(set) var mediaAspectRatio: Float?
    
    @Published private(set) var adLoaded: Bool = false
    @Published private(set) var adLoading: Bool = false

    private var nativeAdSpot: IANativeAdSpot?
    private var nativeAdAssets: IANativeAdAssets?

    func register(
        rootView: UIView? = nil,
        mediaView: UIView? = nil,
        iconView: UIView? = nil,
        clickableViews: [UIView] = []
    ) {
        nativeAdAssets?.registerViewForInteraction(rootView: rootView, mediaView: mediaView, iconView: iconView, clickableViews: clickableViews)
    }

    func load(
        adSource: AdSource = .production,
        timeout: TimeInterval = 15
    ) {
        
        guard let adRequest = IAAdRequest.build( { adRequest in
            adRequest.spotID = AdType.native.spotId
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
        
        self.nativeAdSpot = IANativeAdSpot.build { builder in
            builder.adRequest = adRequest
            builder.delegate = self
        }

        adLoaded = false
        adLoading = true
                
        self.nativeAdSpot?.loadAd(withMarkup: videoAdm) { [weak self] assets, error in
            guard let self else { return }
            self.adLoading = false
            
            if let assets {
                self.adLoaded = true
                                
                self.nativeAdAssets = assets

                self.title = assets.adTitle
                self.adDescription = assets.adDescription
                self.callToActionText = assets.callToActionText
                self.appIcon = assets.appIcon
                self.mediaView = assets.mediaView
                self.rating = assets.rating.map { "\($0.floatValue)" }
                self.mediaAspectRatio = assets.mediaAspectRatio.map { $0.floatValue }
            } else if let error {
                print("Error: \(error)")
            }
        }
    }
}

// MARK: IANativeAdDelegate

extension NativeAdModel: IANativeAdDelegate {
    func iaParentViewController(forAdSpot adSpot: IANativeAdSpot?) -> UIViewController {
        UIApplication.shared.topMostViewController
    }

    func iaNativeAdVideoCompleted(_ adSpot: IANativeAdSpot?) {
        print("\(#function)")
    }
    
    func iaNativeAd(_ adSpot: IANativeAdSpot?, videoInterruptedWithError error: Error) {
        print("\(#function): \(error)")
    }
    
    func iaNativeAd(_ adSpot: IANativeAdSpot?, videoDurationUpdated videoDuration: TimeInterval) {
        print("\(#function)")
    }
    
    func iaNativeAd(_ adSpot: IANativeAdSpot?, videoProgressUpdatedWithCurrentTime currentTime: TimeInterval, totalTime: TimeInterval) {
        //print("Native ad event: progress \(currentTime)/\(totalTime)")
    }
    
    /// Called when the ad unit receives a click.
    func iaNativeAdDidReceiveClick(_ adSpot: IANativeAdSpot?, origin: String?) {
        if let spotId = adSpot?.spotId, let origin {
            print("[SpotId: \(spotId))] Native ad event: click: \(origin)")
        }
    }
    
    /// Called when the ad unit is about to log an impression.
    func iaNativeAdWillLogImpression(_ adSpot: IANativeAdSpot?) {
        print("\(#function)")
    }
        
    func iaNativeAdWillOpenExternalApp(_ adSpot: IANativeAdSpot?) {
        print("\(#function)")
    }
    
    func iaNativeAdDidExpire(_ adSpot: IANativeAdSpot?) {
        print("\(#function)")
    }

    func iaNativeAd(_ adSpot: IANativeAdSpot?, didLoadImageFromUrl url: URL) {
        print("\(#function): \(url)")
    }
    
    func iaNativeAdSpot(_ adSpot: IANativeAdSpot?, didFailToLoadImageFromUrl url: URL, with error: any Error) {
        print("\(#function): \(url), \(error)")
    }
    
    func iaNativeAdWillPresentFullscreen(_ adSpot: IANativeAdSpot?) {
        print("\(#function)")
    }
    
    func iaNativeAdDidPresentFullscreen(_ adSpot: IANativeAdSpot?) {
        print("\(#function)")
    }
    
    func iaNativeAdWillDismissFullscreen(_ adSpot: IANativeAdSpot?) {
        print("\(#function)")
    }

    func iaNativeAdDidDismissFullscreen(_ adSpot: IANativeAdSpot?) {
        print("\(#function)")
    }
}

private let videoAdm = "Cl9odHRwczovL3N0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vZ2NzLWV4Y2hhbmdlLXB1YmxpYy11c2Vhc3QxLXByb2QvY2xpZW50L3Rlc3QvbmF0aXZlSnNvblRlc3QuanNvbhITNjg4MzEzMTQyOTIwODE1MDM1OBoCT0sgACgAMhlJQV9UZXN0RGlzdF8xNTA5NDJfNjMwMzkwQAFI9rwmUKkEWhNGb3Jlc3Rfc2luZ2xlQmlkZGVyYMoGaB5wCnq5AWh0dHBzOi8vZXhjaGFuZ2UtYi1ldmVudHMuaW5uZXItYWN0aXZlLm1vYmkvaW1wcmVzc2lvbj9hZFRpbWU9MTc1MjA2OTkwNjMzOCZhaWQ9NjMwMzkwJmNvdW50aW5nTWV0aG9kPVNESyZuZXR3b3JrPUZvcmVzdF9zaW5nbGVCaWRkZXImcGVyc2lzdGVyPW5ldyZyZXF1ZXN0VHlwZT0xMTQmcz02ODgzMTMxNDI5MjA4MTUwMzU4ggHKAWh0dHBzOi8vZXhjaGFuZ2UtYi1ldmVudHMuaW5uZXItYWN0aXZlLm1vYmkvY2xpY2s/YWRUaW1lPTE3NTIwNjk5MDYzMzgmYWlkPTYzMDM5MCZjb3VudGluZ01ldGhvZD1TREsmbmV0d29yaz1Gb3Jlc3Rfc2luZ2xlQmlkZGVyJnBlcnNpc3Rlcj1uZXcmcmVxdWVzdFR5cGU9MTE0JnJlc3BvbnNlVHlwZT1uZXdDbGljayZzPTY4ODMxMzE0MjkyMDgxNTAzNTjCAbsBaHR0cHM6Ly9leGNoYW5nZS1iLWV2ZW50cy5pbm5lci1hY3RpdmUubW9iaS9hZENvbXBsZXRpb24/YWRUaW1lPTE3NTIwNjk5MDYzMzgmYWlkPTYzMDM5MCZjb3VudGluZ01ldGhvZD1TREsmbmV0d29yaz1Gb3Jlc3Rfc2luZ2xlQmlkZGVyJnBlcnNpc3Rlcj1uZXcmcmVxdWVzdFR5cGU9MTE0JnM9Njg4MzEzMTQyOTIwODE1MDM1OOEBTg9SMV0kYT/qAQlmeWJlci5jb23yAQkyNzEzOTAxMzn6AQkyNzEzOTAxMzmKAkwKI2R5bmFtaWNfY2xvc2VfYnRuX2Rpc3BsYXlfMjBfZHBfaW9zEiVjbG9zZV9idG5fdmlzaWJsZV8yMGRwX2NsaWNrYWJsZV8yMGRwkAKemwk="
