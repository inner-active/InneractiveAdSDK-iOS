////
//  MarketplaceSDK.swift
//  SampleApp
//
//  Created by DT on 18/09/2025.
//  Copyright © 2025 DT. All rights reserved.
//


import SwiftUI
import IASDKCore

class MarketplaceSDK: ObservableObject {
    @Published var muteAudio: Bool =  IASDKCore.sharedInstance().muteAudio {
        didSet {
            IASDKCore.sharedInstance().muteAudio = muteAudio
        }
    }
    
    @Published var userId: String = IASDKCore.sharedInstance().userID ?? "" {
        didSet {
            IASDKCore.sharedInstance().userID = userId
        }
    }
    
    @Published var ccpaString: String = IASDKCore.sharedInstance().ccpaString ?? "" {
        didSet {
            IASDKCore.sharedInstance().ccpaString = ccpaString
        }
    }
    
    @Published var lgpdConsent: IALGPDConsentType = IASDKCore.sharedInstance().lgpdConsent {
        didSet {
            IASDKCore.sharedInstance().lgpdConsent = lgpdConsent
        }
    }
    
    @Published var coppaApplies: IACoppaAppliesType = IASDKCore.sharedInstance().coppaApplies {
        didSet {
            IASDKCore.sharedInstance().coppaApplies = coppaApplies
        }
    }
    
    @Published var gdprConsent: IAGDPRConsentType = IASDKCore.sharedInstance().gdprConsent {
        didSet {
            IASDKCore.sharedInstance().gdprConsent = gdprConsent
        }
    }
    
    @Published var gdprConsentString: String = IASDKCore.sharedInstance().gdprConsentString ?? "" {
        didSet {
            IASDKCore.sharedInstance().gdprConsentString = gdprConsentString
        }
    }
    
    @Published private(set) var sdkInitialized = false

    var version: String {
        IASDKCore.sharedInstance().version()
    }
    
    func initSdk(with appId: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.sdkInitialized = false

            self.initSdkCore(with: appId) { result in
                switch result {
                case .success(_):
                    print("SDK initialization succeeded (App ID: \(appId))")
                    self.sdkInitialized = true
                case .failure(let error):
                    print("SDK initialization (App ID: \(appId)) failed: \(error.localizedDescription)")
                }
            }
        }
    }

    private func initSdkCore(with appId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        IASDKCore.sharedInstance()?.initWithAppID(appId, completionBlock: { success, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }, completionQueue: .main)
    }
}
