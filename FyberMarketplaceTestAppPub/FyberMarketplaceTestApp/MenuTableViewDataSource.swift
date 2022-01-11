//
//  MenuTableViewDataSource.swift
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 23/09/2021.
//  Copyright ©2021 Fyber. All rights reserved.
//

import Foundation

struct TableViewSections:Decodable {
    var title: String
    var adUnits: [AdUnit]
}

class MenuTableViewDataSource:NSObject {
  private var models = [TableViewSections]()
    
    override init() {
        super.init()
        configureCells()
    }
    
    private func configureCells() {
        if let url = Bundle.main.url(forResource: "SampleAds", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                models = try decoder.decode([TableViewSections].self, from: data)
            } catch {
                fatalError("error:\(error)")
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension MenuTableViewDataSource: UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return models[section].title
    }
    
     func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.text = models[section].title
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].adUnits.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].adUnits[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: AdUnitCustomCell.identifier, for: indexPath) as! AdUnitCustomCell 
        cell.configure(with: model)
        return cell
    }
}
