//
//  LoadingView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/5/25.
//


import SwiftUI

struct LoadingView: View {
    var placeholder: String = ""
    var opacity: Double = 0.3
    var backgroundColor: Color = .black
    var tint: Color = .white
    var controllSize: ControlSize = .large
    
    var body: some View {
        ZStack {
            backgroundColor.opacity(opacity)
                .ignoresSafeArea()
            VStack(spacing: 5) {
                ProgressView()
                    .tint(tint)
                    .controlSize(controllSize)
                
                Text(placeholder)
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.5))
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
