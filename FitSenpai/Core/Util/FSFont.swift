//
//  FSFont.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/11/25.
//


enum FSFont: String, CaseIterable {
    case thin
    case thinItalic
    case light
    case lightItalic
    case regular
    case italic
    case medium
    case mediumItalic
    case semibold
    case semiboldItalic
    case bold
    case boldItalic
    case heavy
    case heavyItalic

    var name: String {
        let fontName = "PlusJakartaSans-"
        switch self {
        case .thin: return fontName + "ExtraLight"
        case .thinItalic: return fontName + "ExtraLightItalic"
        case .light: return fontName + "Light"
        case .lightItalic: return fontName + "LightItalic"
        case .regular: return fontName + "Regular"
        case .italic: return fontName + "Italic"
        case .medium: return fontName + "Medium"
        case .mediumItalic: return fontName + "MediumItalic"
        case .semibold: return fontName + "SemiBold"
        case .semiboldItalic: return fontName + "SemiBoldItalic"
        case .bold: return fontName + "Bold"
        case .boldItalic: return fontName + "BoldItalic"
        case .heavy: return fontName + "ExtraBold"
        case .heavyItalic: return fontName + "ExtraBoldItalic"
        }
    }
}
