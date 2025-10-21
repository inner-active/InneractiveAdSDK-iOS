////
//  DisplayAdView.swift
//  SampleApp
//
//  Created by DT on 18/09/2025.
//  Copyright © 2025 DT. All rights reserved.
//


import SwiftUI

struct DisplayAdView: View {
    @StateObject private var model: AdModel
    
    init(model: AdModel) {
        _model = StateObject(wrappedValue: model)
    }

    var body: some View {
        Spacer()

        Button("Load") {
            model.load()
        }
        .font(.largeTitle)
        .disabled(model.adLoading)

        Spacer()
        
        ZStack {
            ZStack {
                Color.gray
                ProgressView()
                    .display(if: model.adLoading)
            }
            
            DisplayAdHostView(model: model)
        }
        .frame(
            width: model.adSize.width,
            height: model.adSize.height
        )
    }
}
