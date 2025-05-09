//
//  FSButton.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import SwiftUI

typealias FSAction = () -> ()

struct FSButton: View {
    @State private var isDisabled = false
    var icon: String?
    var title: String
    var fontStyle: Font = .body16
    var foregroundColor: Color = .fsTitle
    var letterSpace: CGFloat = 0
    var cornerRadius: CGFloat = 6
    var background: Color = .fsPrimary
    var borderColor: Color = .clear
    var size: FSButtonSize = .md
    var tapAction: FSAction
    
    var body: some View {
        Button {
            guard !isDisabled else { return }
            isDisabled = true
            triggerHaptics()
            tapAction()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isDisabled = false
            }
        } label: {
            HStack {
                if let icon {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                }
                FSText(text: title, fontStyle: fontStyle, letterSpace: letterSpace, color: foregroundColor)
            }
            .frame(maxWidth: .infinity, minHeight: size.height, maxHeight: size.height)
            .background(background)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay(
                RoundedCorner(radius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
        .buttonRepeatBehavior(.disabled)
    }
    
    enum FSButtonSize {
        case sm
        case md
        case lg
        
        var height: CGFloat {
            switch self {
            case .sm:
                return 32
            case .md:
                return 50
            case .lg:
                return 60
            }
        }
    }
    
    func triggerHaptics() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

#Preview {
    FSButton(title: "Aloha", tapAction: {})
}

#Preview {
    FSButton(title: "Aloha", tapAction: {})
}
