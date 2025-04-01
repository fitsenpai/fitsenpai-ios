import SwiftUI

struct ThankYouView: View {
    @ObservedObject var viewModel: OnboardingMainViewModel
    var onDismiss: (() -> Void)
    
    @State private var confettiScale: CGFloat = 0.5
    @State private var confettiRotation: Double = -10
    @State private var confettiOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            FSText(text: viewModel.currentStep.title, fontStyle: .heading28, alignment: .center)
            
            if let subtitle = viewModel.currentStep.subtitle {
                FSText(text: subtitle, fontStyle: .body16, alignment: .center)
            }
            
            FSButton(
                title: "Continue",
                fontStyle: .bodyBold16,
                cornerRadius: 32,
                background: .fsPrimary
            ) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.logSelections()
                    onDismiss()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 48)
            
            Spacer()
        }
        .background {
            Image(.confetti)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, -24)
                .scaleEffect(confettiScale)
                .rotationEffect(.degrees(confettiRotation))
                .opacity(confettiOpacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 1.2, dampingFraction: 0.6, blendDuration: 0.6)) {
                            confettiScale = 1
                            confettiRotation = 5
                            confettiOpacity = 1
                        }
                    }
                }
        }
    }
}

struct ConfettiBackground: View {
    var body: some View {
        ZStack {
            ForEach(0..<20) { _ in
                Group {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    FSText(text: "✧", fontStyle: .body16, color: .green)
                    FSText(text: "❋", fontStyle: .body16, color: .green)
                }
                .modifier(RandomlyPositioned())
            }
        }
    }
}

struct RandomlyPositioned: ViewModifier {
    func body(content: Content) -> some View {
        content
            .position(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
            )
            .rotationEffect(.degrees(Double.random(in: 0...360)))
    }
}
