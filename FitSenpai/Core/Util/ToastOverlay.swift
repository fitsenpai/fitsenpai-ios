//
//  ToastOverlay.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/13/25.
//

import SwiftUI

struct ToastView: View {
    let toast: ToastMessage
    let onDismiss: () -> Void
    
    @State private var shakeOffset: CGFloat = 0
    @State private var isShaking = false
    
    var body: some View {
        HStack(spacing: 12) {
            FSTextView(toast.message, typography: .body_medium, color: .black, alignment: .leading)
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(borderColor)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        )
        .offset(x: shakeOffset)
        .onAppear {
            if toast.type == .error {
                startShakeAnimation()
            }
        }
        .onChange(of: toast.id) { _, _ in
            if toast.type == .error {
                startShakeAnimation()
            }
        }
    }
    
    private func startShakeAnimation() {
        shakeOffset = 0
        
        let shakeAnimation = Animation.easeInOut(duration: 0.1).repeatCount(6, autoreverses: true)
        
        withAnimation(shakeAnimation) {
            shakeOffset = 8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = 0
            }
        }
    }
    
    private var bgColor: Color {
        switch toast.type {
        case .success:
            return Color.green.opacity(0.9)
        case .error:
            return Color.red.opacity(0.8)
        case .warning:
            return Color.orange.opacity(0.8)
        case .info:
            return Color.blue.opacity(0.8)
        }
    }
    
    private var borderColor: Color {
        switch toast.type {
        case .success:
            return Color.green.opacity(0.3)
        case .error:
            return Color.red.opacity(0.3)
        case .warning:
            return Color.orange.opacity(0.3)
        case .info:
            return Color.blue.opacity(0.3)
        }
    }
    
    private var iconColor: Color {
        switch toast.type {
        case .success:
            return .green
        case .error:
            return .red
        case .warning:
            return .orange
        case .info:
            return .blue
        }
    }
}

struct ToastOverlay: ViewModifier {
    @StateObject private var toastManager = ToastManager.shared
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if let toast = toastManager.currentToast {
                        VStack {
                            ToastView(toast: toast) {
                                toastManager.dismissToast()
                            }
                            .padding(16)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            Spacer()
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: toastManager.currentToast)
            )
    }
}


extension View {
    /// Adds toast overlay to the view
    func withToastOverlay() -> some View {
        self.modifier(ToastOverlay())
    }
}
