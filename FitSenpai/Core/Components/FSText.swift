//
//  FSText.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import SwiftUI

enum FSTypography {
    case h1
    case h2
    case h3
    case h4
    case large
    case lead
    case p
    case p_ui
    case p_ui_medium
    case p_ui_bold
    case list
    case body
    case body_medium
    case suble
    case suble_medium
    case suble_semibold
    case small
    case detail
    case detail_semi
    case blockquote
    
    var fontSize: CGFloat {
        switch self {
        case .h1:
            48
        case .h2:
            28
        case .h3:
            25
        case .h4, .lead:
            20
        case .large:
            18
        case .p, .p_ui, .p_ui_medium, .p_ui_bold, .list, .blockquote:
            16
        case .body, .body_medium, .suble, .suble_medium,.suble_semibold, .small:
            14
        case .detail_semi:
            12
        case .detail:
            10
        }
    }
    
    var fontName: String {
        switch self {
        case .h1, .h2, .p_ui_bold:
            return FSFont.bold.name
        case .h3, .h4, .large, .detail_semi, .suble, .suble_semibold:
            return FSFont.semibold.name
        case .suble_medium, .p_ui_medium, .body_medium, .detail:
            return FSFont.medium.name
        default:
            return FSFont.regular.name
        }
    }
    
    var letterSpaceTracking: CGFloat {
        switch self {
        case .h2, .body: tracking(fromPercentage: -1, fontSize: fontSize)
        case .h3, .body_medium: tracking(fromPercentage: -2, fontSize: fontSize)
        case .h4: tracking(fromPercentage: -0.5, fontSize: fontSize)
        default: 0
        }
    }
    
    var lineSpacing: CGFloat {
        switch self {
        case .h1:
            return calculateLineSpacing(fromLineHeight: 48, fontSize: fontSize)
        case .h2:
            return calculateLineSpacing(fromLineHeight: 40, fontSize: fontSize)
        case .h3:
            return calculateLineSpacing(fromLineHeight: 32, fontSize: fontSize)
        case .h4, .large, .lead:
            return calculateLineSpacing(fromLineHeight: 28, fontSize: fontSize)
        case .p, .p_ui, .p_ui_medium, .p_ui_bold, .list, .body, .body_medium, .blockquote:
            return calculateLineSpacing(fromLineHeight: 24, fontSize: fontSize)
        case .suble, .suble_medium, .suble_semibold, .detail_semi:
            return calculateLineSpacing(fromLineHeight: 20, fontSize: fontSize)
        case .small:
            return calculateLineSpacing(fromLineHeight: 14, fontSize: fontSize)
        case .detail:
            return calculateLineSpacing(fromLineHeight: 10, fontSize: fontSize)
        }
    }
    
    /// Converts Figma line height to SwiftUI lineSpacing.
    /// - Parameters:
    ///   - lineHeight: The line height in points from Figma.
    ///   - fontSize: The font size in points.
    /// - Returns: Line spacing value for SwiftUI.
    private func calculateLineSpacing(fromLineHeight lineHeight: CGFloat, fontSize: CGFloat) -> CGFloat {
        return (lineHeight - fontSize) / 2
    }
    
    /// Converts Figma letter spacing percentage to SwiftUI point value.
    /// - Parameters:
    ///   - percentage: Letter spacing as a percentage (e.g., -1 for -1%).
    ///   - fontSize: The font size in points (e.g., 20 for 20pt font).
    /// - Returns: Tracking value in points for SwiftUI.
    private func tracking(fromPercentage percentage: CGFloat, fontSize: CGFloat) -> CGFloat {
        return fontSize * (percentage / 100)
    }
}

extension FSTypography {
    enum FontName: String {
        case reg
    }
}

struct FSTextView: View {
    var value: String
    var font: FSFont?
    var typography: FSTypography
    var color: Color
    var alignment: TextAlignment
    var lineLimit: Int? = nil
    var underlined: Bool = false
    var shouldHighlightURLs: Bool = false
    
    init(_ value: String, font: FSFont? = nil, typography: FSTypography, color: Color = .fsBlack, alignment: TextAlignment = .leading, lineLimit: Int? = nil, shouldHighlightURLs: Bool = false) {
        self.value = value
        self.font = font
        self.typography = typography
        self.color = color
        self.alignment = alignment
        self.lineLimit = lineLimit
        self.shouldHighlightURLs = shouldHighlightURLs
    }
    
    private var displayText: Text {
        let localized = LocalizedStringKey(value)
        return shouldHighlightURLs ? Text(localized) : Text(value)
    }

    var body: some View {
        displayText
            .font(.custom(font?.name ?? typography.fontName, size: typography.fontSize))
            .foregroundColor(color)
            .tracking(typography.letterSpaceTracking)
            .underline(underlined)
            .lineSpacing(typography.lineSpacing)
            .disableAutocorrection(true)
            .keyboardType(.asciiCapable)
            .autocapitalization(.none)
            .lineLimit(lineLimit)
            .multilineTextAlignment(alignment)
            .fixedSize(horizontal: false, vertical: true)
    }
}


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
    var alignment: TextAlignment = .leading
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
            .autocapitalization(.none)
            .lineLimit(lineLimit)
            .multilineTextAlignment(alignment)
            .fixedSize(horizontal: false, vertical: true)
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
            .if(frameHeight != nil, transform: { v in
                v.frame(height: frameHeight)
            })
            .dynamicTypeSize(.large)
    }
}

#Preview {
    FSText(text: "Aloha")
}
