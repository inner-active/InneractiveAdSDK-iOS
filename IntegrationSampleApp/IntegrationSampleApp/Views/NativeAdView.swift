////
//  NativeAdView.swift
//  SampleApp
//
//  Created by DT on 18/09/2025.
//  Copyright © 2025 DT. All rights reserved.
//


import SwiftUI
import UIKit
import IASDKCore

// MARK: - Public SwiftUI view you can present from anywhere
struct NativeAdView: View {
    @StateObject private var model: NativeAdModel
    @State private var showFullscreen = false

    init(model: NativeAdModel) {
        _model = StateObject(wrappedValue: model)
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Button("Load") {
                    model.load(/* supply your mock or real request */)
                }
                .font(.largeTitle)
                .disabled(model.adLoading)

                ProgressView().display(if: model.adLoading)
            }

            Button("Show") {
                showFullscreen = true
            }
            .font(.largeTitle)
            .disabled(!model.adLoaded)
            
            Spacer()
        }
        .padding()
        .fullScreenCover(isPresented: $showFullscreen) {
            FullscreenAdContainer(
                viewModel: model,
                onDismiss: { showFullscreen = false }
            )
            .interactiveDismissDisabled(true)
        }
    }
}

// MARK: - Fullscreen container with guaranteed overlay [x] button
struct FullscreenAdContainer: View {
    let viewModel: NativeAdModel
    var onDismiss: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            FullscreenAdRepresentable(viewModel: viewModel)

            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(12)
            }
            .padding(.top, 16)
        }
    }
}

// MARK: - Representable that hosts the UIKit full-screen ad VC
struct FullscreenAdRepresentable: UIViewControllerRepresentable {
    let viewModel: NativeAdModel

    func makeUIViewController(context: Context) -> UIKitNativeAdFullScreenLayout {
        UIKitNativeAdFullScreenLayout(viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: UIKitNativeAdFullScreenLayout, context: Context) {
    }
}

// MARK: - UIKit layout
final class UIKitNativeAdFullScreenLayout: UIViewController {
    // Dependencies
    private let viewModel: NativeAdModel

    // Placeholders
    private let container   = UIView()
    private let iconHolder  = UIView()
    private let mediaHolder = UIView()
    private let titleLabel  = UILabel()
    private let ratingLabel = UILabel()
    private let bodyLabel   = UILabel()
    private let ctaButton   = UIButton(type: .system)

    private let m: CGFloat = 8

    private var mediaViewAspectRation: CGFloat {
        let defaultValue = 0.62
        guard let ratio = viewModel.mediaAspectRatio else { return defaultValue }
        return CGFloat(1.0 / ratio)
    }

    // Init
    init(viewModel: NativeAdModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        // Tag clickable assets for the SDK
        container.tag   = ViewTag.root.rawValue
        mediaHolder.tag = ViewTag.mediaView.rawValue
        iconHolder.tag  = ViewTag.icon.rawValue
        titleLabel.tag  = ViewTag.title.rawValue
        ctaButton.tag   = ViewTag.cta.rawValue
        ratingLabel.tag = ViewTag.rating.rawValue
        bodyLabel.tag   = ViewTag.description.rawValue

        // Register with SDK
        viewModel.register(
            rootView: container,
            mediaView: mediaHolder,
            iconView: iconHolder,
            clickableViews: [titleLabel, ratingLabel, bodyLabel, ctaButton]
        )
    }

    required init?(coder: NSCoder) { fatalError("Use init(viewModel:)") }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildHierarchy()
        styleViews()
        buildConstraints()
        bindViewModel()
    }

    // MARK: Building
    private func buildHierarchy() {
        view.addSubview(container)
        [iconHolder, titleLabel, ratingLabel, mediaHolder, bodyLabel, ctaButton]
            .forEach { container.addSubview($0) }
    }

    private func styleViews() {
        view.backgroundColor = .systemBackground

        container.backgroundColor = UIColor(white: 0.92, alpha: 1)
        container.layer.cornerRadius = 4
        container.translatesAutoresizingMaskIntoConstraints = false

        [iconHolder, mediaHolder].forEach {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        titleLabel.numberOfLines = 2
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .black

        ratingLabel.font = .systemFont(ofSize: 12)
        ratingLabel.textColor = .black

        bodyLabel.font = .systemFont(ofSize: 12)
        bodyLabel.textColor = .black
        bodyLabel.numberOfLines = 0

        [titleLabel, ratingLabel, bodyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        ctaButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
        ctaButton.setTitleColor(.white, for: .normal)
        ctaButton.layer.cornerRadius = 3
        ctaButton.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 15.0, *) {
            var cfg = UIButton.Configuration.filled()
            cfg.baseBackgroundColor = .systemBlue
            cfg.baseForegroundColor = .white
            cfg.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 18, bottom: 6, trailing: 18)
            ctaButton.configuration = cfg
        } else {
            ctaButton.backgroundColor  = .systemBlue
            ctaButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 18, bottom: 6, right: 18)
        }
    }

    private func buildConstraints() {
        let ctaHeight: CGFloat = 52
        let shift: CGFloat = 0

        let contentGap = UILayoutGuide()
        container.addLayoutGuide(contentGap)

        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        ratingLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        bodyLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        bodyLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

        let minBodyHeight = max(ceil(bodyLabel.font.lineHeight), 18)
        bodyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minBodyHeight).isActive = true

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.topAnchor, constant: m + 16),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: m),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -m),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -m),

            iconHolder.topAnchor.constraint(equalTo: container.topAnchor, constant: m + shift),
            iconHolder.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: m),
            iconHolder.widthAnchor.constraint(equalToConstant: 60),
            iconHolder.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.topAnchor.constraint(equalTo: iconHolder.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconHolder.trailingAnchor, constant: m),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -m),

            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            ctaButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            ctaButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            ctaButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -m),
            ctaButton.heightAnchor.constraint(equalToConstant: ctaHeight),

            contentGap.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            contentGap.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            contentGap.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: m),
            contentGap.bottomAnchor.constraint(equalTo: ctaButton.topAnchor, constant: -m),

            mediaHolder.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: m),
            mediaHolder.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -m),
            {
                let c = mediaHolder.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: m)
                c.priority = .defaultHigh; return c
            }(),
            {
                let c = mediaHolder.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -m)
                c.priority = .defaultHigh; return c
            }(),
            mediaHolder.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            mediaHolder.centerYAnchor.constraint(equalTo: contentGap.centerYAnchor),
            mediaHolder.topAnchor.constraint(greaterThanOrEqualTo: contentGap.topAnchor),
            mediaHolder.bottomAnchor.constraint(lessThanOrEqualTo: contentGap.bottomAnchor),

            bodyLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: m),
            bodyLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -m),
            bodyLabel.topAnchor.constraint(equalTo: mediaHolder.bottomAnchor, constant: m),
            bodyLabel.bottomAnchor.constraint(lessThanOrEqualTo: ctaButton.topAnchor, constant: -m),
        ])

        let aspect = mediaHolder.heightAnchor.constraint(
            equalTo: mediaHolder.widthAnchor,
            multiplier: mediaViewAspectRation
        )
        aspect.priority = .required
        aspect.isActive = true

        let cap = mediaHolder.heightAnchor.constraint(lessThanOrEqualTo: contentGap.heightAnchor)
        cap.priority = .required
        cap.isActive = true
    }

    // MARK: Binding
    private func bindViewModel() {
        titleLabel.text = viewModel.title
        ratingLabel.text = "Rating: \(viewModel.rating ?? "")"
        bodyLabel.text = viewModel.adDescription
        ctaButton.setTitle(viewModel.callToActionText, for: .normal)

        if let icon = viewModel.appIcon { embed(icon, in: iconHolder) }
        if let media = viewModel.mediaView { embed(media, in: mediaHolder) }
    }

    // Helpers
    private func embed(_ child: UIView, in holder: UIView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        holder.addSubview(child)
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: holder.topAnchor),
            child.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            child.trailingAnchor.constraint(equalTo: holder.trailingAnchor),
            child.bottomAnchor.constraint(equalTo: holder.bottomAnchor)
        ])
    }
}
