//
//  IAMediationsProtocol .swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 05/05/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

protocol SampleSDKProtocolDelegate: AnyObject {
    func adDidLoad(with type: SampleAdTypeEnum)
    func adFailedToLoad(with error: String)
    func addConstraint(for adView: UIView)
    func adDidResize(to frame: CGRect)
}

protocol SampleSDKProtocol {
    // MARK: - Properties
    
    var presentingViewController: AdViewController! { get set }
    var delegate: SampleSDKProtocolDelegate? {get set}
    var requestAdType: SampleAdTypeEnum? { get set }
    
    // MARK: - FMPMediationsAPIProtocol API
    
    init(presentingViewController: AdViewController)
    
    func loadAd()
    func showInterstitial()
    func disposeSDKInstance()
    
    static func showMediationDebugger()
}
