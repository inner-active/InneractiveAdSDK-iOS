//
//  NewAdUnitController.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 30/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit

class NewAdUnitController: UIViewController {
    private let dataSource = NewAdUnitDataSource()
    private let router: Router = RouterImpl()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var qrButton: UIBarButtonItem!
    private var adUnitToEdit: AdUnit?
    private var isEditingExistingAdUnit: Bool {
        return self.adUnitToEdit != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustUIForDarkModeIfNeeded()
        setupTableView()
        resetLastNewAdUnitIfNeeded()
       
        if isEditingExistingAdUnit {
            fillSubviewsWithAdUnitValues()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        toggleIsEditingFlagIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.route(with: segue, sender: sender)
    }
    
    // MARK: - IBAction
    @IBAction func QRButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: StoryboardsSegues.showScannerSegue.rawValue, sender: ClientRequestSettings.shared)
    }
    
    @IBAction func saveAdClicked() {
        if isEditingExistingAdUnit {
            SavedAdsManager.sharedInstance.removeSavedAd(adUnit: adUnitToEdit!)
        }
        
        let adUnitResult = dataSource.createNewAdUnit()
        
        do {
            _ = try adUnitResult.get()
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            alertUser(message: error.localizedDescription)
        }
    }
}

// MARK: - API
extension NewAdUnitController {
    func configureToEdit(adUnit: AdUnit) {
        self.adUnitToEdit = adUnit
    }
}

// MARK: - Setup
private extension NewAdUnitController {
    func toggleIsEditingFlagIfNeeded() {
        ClientRequestSettings.shared.didShowEditingViewController()
    }
    
    func fillSubviewsWithAdUnitValues() {
        guard let adUnitToEdit = self.adUnitToEdit else {return}
        ClientRequestSettings.shared.valueDidChange(for: .adFormat, with: adUnitToEdit.format.rawValue)
        ClientRequestSettings.shared.valueDidChange(for: .spotIdNew, with: adUnitToEdit.spotId)
        ClientRequestSettings.shared.valueDidChange(for: .portalNew, with: adUnitToEdit.portal ?? "")
        ClientRequestSettings.shared.valueDidChange(for: .mockName, with: adUnitToEdit.id ?? "")
    }
    
    func adjustUIForDarkModeIfNeeded() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                qrButton.tintColor = .white
                tableView.backgroundColor = .black
            }
        }
    }
    
    func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.register(MultiValuesCustomCell.nib(), forCellReuseIdentifier: MultiValuesCustomCell.identifier)
        tableView.register(TextFieldCustomCell.nib(), forCellReuseIdentifier: TextFieldCustomCell.identifier)
    }
    
    func resetLastNewAdUnitIfNeeded() {
        ClientRequestSettings.shared.resetNewMockName()
    }
}

// MARK: - UITableview Delegate
extension NewAdUnitController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MultiValuesCustomCell else { return }
    
        performSegue(withIdentifier: StoryboardsSegues.showMultiValue.rawValue, sender: cell)
    }
}
