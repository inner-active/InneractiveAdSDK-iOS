//
//  NewAdUnitController.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 30/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import UIKit

class NewAdUnitController: UIViewController {
   private let dataSource = NewAdUnitDataSource()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var qrButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                qrButton.tintColor = .white
                tableView.backgroundColor = .black
            }
        }
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.register(MultiValuesCustomCell.nib(), forCellReuseIdentifier: MultiValuesCustomCell.identifier)
        tableView.register(TextFieldCustomCell.nib(), forCellReuseIdentifier: TextFieldCustomCell.identifier)
        //Reset if not nil
        ClientRequestSettings.shared.resetNewMockName()
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardsSegues.multiValueShowSegue.rawValue {
            let controller = segue.destination as! MultiValueTableViewController
            controller.configure(with: sender as! MultiValuesCustomCell) 
            
        } else if segue.identifier == StoryboardsSegues.showScannerSegue.rawValue {
            let controller = segue.destination as! ScannerViewController
            controller.delegate = ClientRequestSettings.shared
            
        } else if segue.identifier == StoryboardsSegues.ShowAdVCSegue.rawValue {
            let adUnit = sender as! AdUnit
            ClientRequestSettings.shared.updateClientRequest(with: adUnit)
            
            let controller = segue.destination as! AdViewController
            controller.setup(with: MarketplaceSDK(presentingViewController: controller), adType: adUnit.format, title: adUnit.id)
        }
    }
    
    //MARK: - Service
    
    @IBAction func saveAdClicked() {
        let adUnit:AdUnit? = dataSource.createNewAdUnit()
        if let adUnit = adUnit {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            performSegue(withIdentifier: StoryboardsSegues.ShowAdVCSegue.rawValue, sender: adUnit)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            alertUser(message: "Mock Name is Empty!")
        }
    }
}

//MARK: - UITableview Delegate

extension NewAdUnitController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MultiValuesCustomCell else { return }
        
        performSegue(withIdentifier: StoryboardsSegues.multiValueShowSegue.rawValue, sender: cell)
    }
}
