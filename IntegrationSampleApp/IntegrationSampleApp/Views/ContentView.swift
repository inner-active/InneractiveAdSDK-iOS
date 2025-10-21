////
//  ContentView.swift
//  SampleApp
//
//  Created by DT on 18/09/2025.
//  Copyright © 2025 DT. All rights reserved.
//

import SwiftUI
import IASDKCore

struct ContentView: View {
    enum SelectedView: String, CaseIterable, Identifiable {
        case banner = "Banner"
        case mrec = "Mrec"
        case interstitial = "Interstitial"
        case rewarded = "Rewarded"
        case native = "Native"

        var id: String { rawValue }
    }
    
    @State private var selection: SelectedView = .native
    
    var body: some View {
        VStack {
            Picker("Select a View", selection: $selection) {
                ForEach(SelectedView.allCases) { viewCase in
                    Text(viewCase.rawValue).tag(viewCase)
                }
            }
            .pickerStyle(.menu)
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            switch selection {
            case .banner:
                DisplayAdView(model: .init(.display(.banner)))
            case .mrec:
                DisplayAdView(model: .init(.display(.mrec)))
            case .interstitial:
                FullscreenAdView(model: .init(.fullscreen(.interstitial)))
            case .rewarded:
                FullscreenAdView(model: .init(.fullscreen(.rewarded)))
            case .native:
                NativeAdView(model: .init())
            }
        }
        .padding(.bottom, 16)
    }
}
