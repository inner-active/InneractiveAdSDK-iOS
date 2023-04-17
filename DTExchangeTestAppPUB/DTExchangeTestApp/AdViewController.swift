//
//  FMPAdViewController.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 23/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit

class AdViewController: UIViewController {
    static var shouldAutoLoad = false
    private var isLoadingAd = false
    private var sdkInstance: SampleSDKProtocol!
    private var adType: SampleAdTypeEnum!
    private var userAlertLabel: UILabel?
    private var adViewContent: AdViewControllerContentState!
    private var router: Router = RouterImpl()
    private var inFocus = true
    @IBOutlet weak var loadAdButton: UIButton!
    @IBOutlet weak var showAdButton: UIButton!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var adViewHeight: NSLayoutConstraint!
    @IBOutlet weak var adViewWidth: NSLayoutConstraint!
    @IBOutlet weak var loadAdTopConstraintsToScrollViewTopForAdView: NSLayoutConstraint!
    @IBOutlet weak var loadAdTopConstraintToScrollViewTopForInterstitialView: NSLayoutConstraint!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()

        navigationItem.rightBarButtonItems?.removeAll(where: {$0.title == "Settings"})
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIApplication.shared.statusBarOrientation != .unknown {
            adViewContent.adjustLoadAdTopConstraint()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inFocus = true
        prepareSubViewToCorrectState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard inFocus else { return }
        
        let didReturnToMenu = self.view.window == nil && self.view.superview == nil
        
        if didReturnToMenu {
            sdkInstance?.disposeSDKInstance()
            sdkInstance = nil
        }
    }
    
    // MARK: - IBOutlets
    
    @IBAction func loadAdClicked(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        loadAd()
    }

    @IBAction func showAdClicked(_ sender: Any) {
        loadAdButton.isUserInteractionEnabled = false
        loadAdButton.isEnabled = false
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        sdkInstance.showInterstitial()
        showAdButton.isHidden = true
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.route(with: segue, sender: true)
    }

    // MARK: - deInit
    
    deinit {
        Console.shared.add(message: "\(String(describing: self)) deinit")
    }
}

// MARK: - API

extension AdViewController {
    func setup(with sdk: SampleSDKProtocol, adType: SampleAdTypeEnum, title: String) {
        sdkInstance = sdk
        sdkInstance.requestAdType = adType
        sdkInstance.delegate = self
        self.adType = adType
        self.title = title
    }
}

// MARK: - Service

private extension AdViewController {
    func setupSubViews() {
        setupAdViewContent()
        setupSpinnerStyle()

        if adType.isInterstitial() {
            setupSubViewsForInterstitialAds()
        } else {
            setupSubviewsForNonInterstitialAds()
        }
    }

    func setupSpinnerStyle() {
        if #available(iOS 13.0, *) {
            spinner.style = .large
        }
    }

    func setupAdViewContent() {
        adViewContent = AdViewControllerContentState(with: adType)
        adViewContent.delegate = self
        adViewContent.adjustLoadAdTopConstraint()
    }

    func setupSubViewsForInterstitialAds() {
        loadAdTopConstraintToScrollViewTopForInterstitialView.priority = .defaultHigh
        loadAdTopConstraintsToScrollViewTopForAdView.priority = .defaultLow
    }
    
    func setupSubviewsForNonInterstitialAds() {
        adView.isHidden = false

        if (adType == .rectangle) || (adType == .banner) {
            adViewHeight.constant = adType.size.height
            adViewWidth.constant  = adType.size.width
        }
    }

    func prepareSubViewToCorrectState() {
        loadAdButton.isUserInteractionEnabled = true
        loadAdButton.isEnabled = true
        tabBarController?.tabBar.isHidden = true
        removeUserAlertLabelIfNeeded()
    }

    func loadAd() {
        if !isLoadingAd {
            Console.shared.add(message: "will start loading ad... ", messageType: .debug)
            isLoadingAd = true
            sdkInstance?.loadAd()
            showAdButton.isHidden = true
            spinner.startAnimating()
        } else {
            Console.shared.add(message: "loading ad is already in progress... ", messageType: .error)
        }
    }

    func removeUserAlertLabelIfNeeded() {
        guard let userAlertLabel = self.userAlertLabel else {return}
        UIView.animate(withDuration: 0.5, delay: 3) {
            userAlertLabel.alpha = 0
        } completion: { res in
            guard res else { return }
            userAlertLabel.removeFromSuperview()
            self.userAlertLabel = nil
        }
    }
}

// MARK: - FMPSDKProtocolDelegate

extension AdViewController: SampleSDKProtocolDelegate {
    func adDidLoad(with type: SampleAdTypeEnum) {
        DispatchQueue.main.async {
            self.isLoadingAd = false
            self.spinner.stopAnimating()
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.showAdButton.isHidden = !type.isInterstitial()

            Console.shared.add(message: "ad of type: \(type.stringValue) was loaded")
        }
    }

    func adFailedToLoad(with error: String) {
        DispatchQueue.main.async {
            self.isLoadingAd = false
            self.showAdButton.isHidden = true
            self.spinner.stopAnimating()
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            self.showError(with: "ad load failed: \(error)")
            Console.shared.add(message: "ad load failed: \(error)")
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

    func adDidResize(to frame: CGRect) {
        adViewWidth.constant = frame.width
        adViewHeight.constant = frame.height
    }
}

// MARK: - UI Utils

extension AdViewController {
    func showError(with message: String) {
        if userAlertLabel != nil {
            userAlertLabel!.removeFromSuperview()
            userAlertLabel = nil
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
            self.view.addConstraint(
                NSLayoutConstraint.init(
                    item: userAlertLabel,
                    attribute: .centerX,
                    relatedBy: .equal,
                    toItem: self.view,
                    attribute: .centerX,
                    multiplier: 1,
                    constant: 0))
            self.view.addConstraint(
                NSLayoutConstraint.init(
                    item: userAlertLabel,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: self.view,
                    attribute: .width,
                    multiplier: 0.8,
                    constant: 0))
            self.view.addConstraint(
                NSLayoutConstraint.init(
                    item: userAlertLabel,
                    attribute: .centerY,
                    relatedBy: .equal,
                    toItem: self.view,
                    attribute: .centerY,
                    multiplier: 1,
                    constant: 0))

            UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction) {
                userAlertLabel.alpha = 1
            } completion: { res in
                guard res else { return }
                self.removeUserAlertLabelIfNeeded()
            }
        }
    }
}

// MARK: - AdViewContentStateDelegate
extension AdViewController: AdViewContentStateDelegate {
    func updateAdViewConstraintForAdView(with constant: CGFloat) {
        loadAdTopConstraintsToScrollViewTopForAdView.constant = constant
    }

    func updateAdViewConstraintForAdInterstitialView(with constant: CGFloat) {
        loadAdTopConstraintToScrollViewTopForInterstitialView.constant = constant
    }
}
