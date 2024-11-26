//
//  FSText.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import SwiftUI


struct FSText: View {
    var text: String
    var fontStyle: Font = .body14
    var letterSpace: CGFloat = 0.3
    var color = Color.fsTitle
    var frameHeight: CGFloat?
    var lineSpacing: CGFloat = 0
    var isUnderlined: Bool = false
    var selectionAllowed = false
    var truncationMode: Text.TruncationMode?
    var lineLimit: Int?
    var alignment: TextAlignment?
    var shouldHighlightURLs: Bool = false
    
    private var displayText: Text {
        let localized = LocalizedStringKey(text)
        return shouldHighlightURLs ? Text(localized) : Text(text)
    }
    
    
    var body: some View {
        displayText
            .font(fontStyle)
            .foregroundColor(color)
            .tracking(letterSpace)
            .if(isUnderlined, transform: { t in
                t.underline()
            })
            .accentColor(.fsPrimary)
            .lineSpacing(lineSpacing)
            .disableAutocorrection(true)
            .keyboardType(.asciiCapable)
            .if(selectionAllowed) { v in
                    v.contextMenu(ContextMenu(menuItems: {
                      Button("Copy", action: {
                        UIPasteboard.general.string = text
                      })
                    }))
            }
            .if(truncationMode != nil, transform: { v in
                    v.truncationMode(truncationMode!)
            })
            .if(lineLimit != nil, transform: { v in
                v.lineLimit(lineLimit!)
            })
            .if(frameHeight != nil, transform: { v in
                v.frame(height: frameHeight)
            })
            .if(alignment != nil, transform: { v in
                v.multilineTextAlignment(alignment!)
            })
            .dynamicTypeSize(.large)
    }
}

#Preview {
    FSText(text: "Aloha")
}
