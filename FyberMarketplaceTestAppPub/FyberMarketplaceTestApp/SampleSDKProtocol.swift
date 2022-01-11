//
//  IAMediationsProtocol .swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 05/05/2021.
//  Copyright © 2021 Fyber. All rights reserved.
//

import Foundation

protocol SampleSDKProtocolDelegate {
    func adDidLoad(with type:SampleAdType)
    func adFailedToLoad(with error: String)
    func addConstraint(for adView: UIView)
    func adDidResize(to frame:CGRect) 
}

protocol SampleSDKProtocol {
    
    //MARK: - Properties
    var presentingViewController: AdViewController! { get set }
    var delegate: SampleSDKProtocolDelegate? {get set}
    var requestAdType: SampleAdType? { get set }
    
    //MARK: - FMPMediationsAPIProtocol API
    
    /// - Parameter presentingViewController: the view controller that was specified when implementing the SDK instance delegate protocol.
    init(presentingViewController: AdViewController)
    
    func loadAd() -> Void
    
    func showInterstitial() -> Void
}
