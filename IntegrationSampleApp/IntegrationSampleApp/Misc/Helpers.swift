////
//  Helpers.swift
//  SampleApp
//
//  Created by DT on 18/09/2025.
//  Copyright © 2025 DT. All rights reserved.
//


import SwiftUI
import IASDKCore

struct DisplayAdHostView: UIViewRepresentable {
    @ObservedObject var model: AdModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if model.adLoaded {
            model.show(in: uiView)
        }
    }
}

struct UIKitViewControllerWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController
    func makeUIViewController(context: Context) -> UIViewController {
        viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

extension UIApplication {
    var topMostViewController: UIViewController {
        // root of the active window
        guard let root = connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first?.rootViewController else { return UIViewController() }
        return root
    }
}

extension View {
    @ViewBuilder
    func display(if condition: Bool) -> some View {
        if condition { self } else { EmptyView() }
    }
}
