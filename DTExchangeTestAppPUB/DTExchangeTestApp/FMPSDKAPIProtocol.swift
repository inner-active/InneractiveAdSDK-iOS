//
//  IAMediationsProtocol .swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 05/05/2021.
//  Copyright © 2021 Fyber. All rights reserved.
//

import Foundation

protocol FMPSDKProtocolDelegate: AnyObject {
    func adDidLoad()
    func adFailedToLoad(with error: String)
}

protocol FMPSDKProtocol {
    // MARK: - Properties
    
    var presentingViewController: UIViewController! { get set }
    var delegate: FMPSDKProtocolDelegate? {get set}
    var requestAdType: SampleAdType? { get set }
    
    // MARK: - FMPMediationsAPIProtocol API
    
    /* Mediation instance must receive the presenting view controller when initialize.*/
    init(presentingViewController: UIViewController)
    
    func loadAd()
    
    func showInterstitial()
}
