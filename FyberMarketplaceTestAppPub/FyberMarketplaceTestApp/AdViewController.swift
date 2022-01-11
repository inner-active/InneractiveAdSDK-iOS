//
//  FMPAdViewController.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 23/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import UIKit
import AudioToolbox

class AdViewController: UIViewController {
    static var shouldAutoLoad = false
    private var sdkInstance: SampleSDKProtocol!
    private var adType: SampleAdType!
    private var userAlertLabel: UILabel?
    
    @IBOutlet weak var loadAdBtn: UIButton!
    @IBOutlet weak var showAdBtn: UIButton!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var adView_height: NSLayoutConstraint!
    @IBOutlet weak var adView_width: NSLayoutConstraint!
  

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems?.removeAll(where: {$0.title == "Settings"})
        
        if #available(iOS 13.0, *) {
            spinner.style = .large
        }
        
        if (!adType.isInterstitial()) {
            setupSubviewsForNonInterstitialAds()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            self.navigationController?.popToRootViewController(animated: true)
            sdkInstance = nil
        }
    }

    //MARK: - Service
    
    internal func setup(with sdk:SampleSDKProtocol, adType:SampleAdType, title:String) {
        sdkInstance = sdk
        sdkInstance.requestAdType = adType
        sdkInstance.delegate = self
        self.adType = adType
        self.title = title
    }
    
    private func setupSubviewsForNonInterstitialAds() {
        adView.isHidden = false
        if ((adType == .Rectangle) || (adType == .Banner)) {
            adView_height.constant = adType.size.height
            adView_width.constant  = adType.size.width
        }
    }
    
    private func loadAd() {
        sdkInstance.loadAd()
        showAdBtn.isHidden = true
        spinner.startAnimating()
        saveCurrentAdToUserDefaultsIfNeeded()
    }
    
    private func saveCurrentAdToUserDefaultsIfNeeded() {
        if isLoadAdAfterStartupEnabled() {
            let defaults = UserDefaults.standard
            
            defaults.set(adType.rawValue, forKey: UserDefaultsKey.SampleAdType.rawValue)
            ClientRequestSettings.shared.saveCurrentAdToUserDefaults()
        }
    }
    
    private func isLoadAdAfterStartupEnabled() -> Bool {
        if let value = ClientRequestSettings.shared.getValue(of: .ShouldLoadCurrentAdAfterStartup), value == "true", sdkInstance is MarketplaceSDK {
            return true
        }
        
        return false
    }
    
    //MARK: - IBOutlets
    
    @IBAction func LoadAdClicked(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        loadAd()
    }
    
    @IBAction func ShowAdClicked(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        sdkInstance.showInterstitial()
        showAdBtn.isHidden = true
    }
    
    //MARK: - deInit
    
    deinit {
        Console.shared.add(message: "\(String(describing: self)) deinit")
    }
}

//MARK: - FMPSDKProtocolDelegate

extension AdViewController: SampleSDKProtocolDelegate {
    func adDidLoad(with type: SampleAdType) {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.showAdBtn.isHidden = !type.isInterstitial()
            
            Console.shared.add(message: "Ad with type: \(type.stringValue) was loaded")
        }
    }
    
    func adFailedToLoad(with error: String) {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            self.showError(with: "Failed to load Ad with error: \(error)")
            Console.shared.add(message: "Failed to load ad with error: \(error)")
        }
    }
    
    func addConstraint(for adView: UIView) {
        adView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            adView.widthAnchor.constraint(equalToConstant: adView.frame.size.width),
            adView.heightAnchor.constraint(equalToConstant: adView.frame.size.height),
            adView.centerXAnchor.constraint(equalTo: self.adView.centerXAnchor),
            adView.centerYAnchor.constraint(equalTo: self.adView.centerYAnchor)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func adDidResize(to frame:CGRect) {
        adView_height.constant = frame.width
        adView_height.constant = frame.height
    }
}

//MARK: - UI Utils

extension AdViewController {
    func showError(with message: String) {
        if userAlertLabel != nil {
            userAlertLabel!.removeFromSuperview()
            userAlertLabel = nil;
        }
        userAlertLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: self.view.frame.height/5))
        userAlertLabel!.text = message
        userAlertLabel!.lineBreakMode = .byWordWrapping
        userAlertLabel!.numberOfLines = 10
        userAlertLabel!.font = .systemFont(ofSize: 15)
        userAlertLabel!.translatesAutoresizingMaskIntoConstraints = false
        userAlertLabel!.alpha = 0
        
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .light {
                userAlertLabel!.textColor = .black
            }
        }
        
        DispatchQueue.main.async {
            guard let userAlertLabel = self.userAlertLabel else {return}
            self.view.addSubview(userAlertLabel)
            self.view.addConstraint(NSLayoutConstraint.init(item: userAlertLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint.init(item: userAlertLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.8, constant: 0))
            self.view.addConstraint(NSLayoutConstraint.init(item: userAlertLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
            
            UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction) {
                userAlertLabel.alpha = 1
            } completion: { res in
                guard res else { return }
                UIView.animate(withDuration: 0.5 , delay: 3) {
                    userAlertLabel.alpha = 0
                } completion: { (res) in
                    guard res else { return }
                    userAlertLabel.removeFromSuperview()
                    self.userAlertLabel = nil;
                }
            }
        }
    }
}
