////
//  InterstitialAdView.swift
//  SampleApp
//
//  Created by DT on 18/09/2025.
//  Copyright © 2025 DT. All rights reserved.
//


import SwiftUI



struct FullscreenAdView: View {
    @StateObject private var model: AdModel
    
    init(model: AdModel) {
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        Spacer()

        VStack(spacing: 20) {
            ZStack {
                Button("Load") {
                  //  model.load(adSource: .production)
                    model.load(adSource: .mock(.init(with: model.adType)))
                }
                .font(.largeTitle)
                .disabled(model.adLoading)
                
                ProgressView()
                    .display(if: model.adLoading)
            }
            
            Button("Show") {
                model.show()
            }
            .font(.largeTitle)
            .disabled(!model.adLoaded)
        }
        
        Spacer()        
    }
}
