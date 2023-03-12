//
//  MultiValueTableViewController.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 29/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit

class MultiValueTableViewController: BaseTableViewController {
    private var model: MultiValuesCustomCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = model.title.text
    }
    
    internal func configure(with model: MultiValuesCustomCell) {
        self.model = model
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = model.options[indexPath.row]
        if indexPath == model.selectedRow {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: model.selectedRow!)?.accessoryType = .none // remove checkmark from previouse cell
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        model.selectedRow = indexPath
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    // MARK: - IBAction
    @IBAction func doneButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
