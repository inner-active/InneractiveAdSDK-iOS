//
//  UIVIewControllerExtensions.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 31/08/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import Foundation

extension UIViewController {
    func alertUser(message: String, title: String = "", onCompletion: (() -> Void)? = { return }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            onCompletion!()
        })
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addButtonAction(_ sender: Any, delegate: ScannerViewControllerDelegate?) {
        performSegue(withIdentifier: StoryboardsSegues.ShowNewAdUnitSegue.rawValue, sender: nil)
        
    }
}
