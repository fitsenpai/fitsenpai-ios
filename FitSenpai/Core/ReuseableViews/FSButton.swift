//
//  FSButton.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import SwiftUI

typealias FSAction = () -> ()

struct FSButton: View {
    var icon: String?
    var title: String
    var fontStyle: Font = .body16
    var foregroundColor: Color = .fsTitle
    var letterSpace: CGFloat = 1.5
    var cornerRadius: CGFloat = 6
    var background: Color = .fsPrimary
    var borderColor: Color = .clear
    var tapAction: FSAction
    
    var body: some View {
        Button {
            tapAction()
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
            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
            .background(background)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay(
                RoundedCorner(radius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
    FSButton(title: "Aloha", tapAction: {})
}

#Preview {
    FSButton(title: "Aloha", tapAction: {})
}
