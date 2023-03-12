//
//  ConsoleViewController.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 09/11/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit

class ConsoleViewController: UIViewController {
    static let identifier = "ConsoleViewController"
    
    @IBOutlet private var expandOrCollapse: UIButton!
    @IBOutlet private var console: UIView!

    // swiftlint:disable private_outlet
    @IBOutlet private(set) var textView: UITextView!
    @IBOutlet private(set) var tipView: UIView!
    // swiftlint:enable private_outlet

    @IBOutlet private var consoleHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var consoleBottomConstraint: NSLayoutConstraint!

    var isExpanded = false

    // MARK: Init
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    private func initSubViews() {
        let nib = UINib(nibName: String(describing: ConsoleViewController.self), bundle: Bundle(for: ConsoleViewController.self))
        nib.instantiate(withOwner: self, options: nil)
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .coverVertical
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.backgroundColor = .white

        if isExpanded {
            expandConsole()
        } else {
            collapseConsole()
        }

        expandOrCollapse.isSelected = isExpanded

        consoleBottomConstraint.constant = -console.bounds.height
        view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateConsoleIn()
    }

    // MARK: - UI

    private func animateConsoleIn() {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }

        consoleBottomConstraint.constant = 0

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func animateConsoleOut() {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .clear
        }

        consoleBottomConstraint.constant = -console.bounds.height

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false)
        })
    }

    // MARK: - Actions

    @IBAction private func dismiss() {
        animateConsoleOut()
    }

    @IBAction private func expandOrCollapseConsole() {
        if isExpanded {
            collapseConsole()
        } else {
            expandConsole()
        }

        isExpanded = !isExpanded
        expandOrCollapse.isSelected = !expandOrCollapse.isSelected
    }

    private func expandConsole() {
        updateConsoleHeight(heightMultiplier: 0.75)
    }

    private func collapseConsole() {
        updateConsoleHeight(heightMultiplier: 0.35)
    }

    private func updateConsoleHeight(heightMultiplier: CGFloat) {
        view.removeConstraint(consoleHeightConstraint)

        consoleHeightConstraint = NSLayoutConstraint(
            item: console as Any, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: heightMultiplier, constant: 0)

        view.addConstraint(consoleHeightConstraint)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
