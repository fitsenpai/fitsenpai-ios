//
//  FSColor.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import Foundation
import UIKit
import SwiftUI


class FSColor {
    static let primary = UIColor(hexString: AppColor.Green.rawValue)
    static let secondary = UIColor(hexString: AppColor.MutedGreen.rawValue)
    static let title = UIColor(hexString: AppColor.Foreground.rawValue)
    static let subtitle = UIColor(hexString: AppColor.MutedForeground.rawValue)
    static let blackBackground = UIColor(hexString: AppColor.Black.rawValue)
    static let deepBlackBackground = UIColor(hexString: AppColor.DeepBlack.rawValue)
    static let gray26 = UIColor(hexString: AppColor.LightGray.rawValue)
    
}

enum AppColor: String {
    case Foreground           = "#111604"
    case MutedForeground      = "#666666"
    case Black                = "#181818"
    case DeepBlack            = "#070901"
    case Green                = "#A8DE24"
    case MutedGreen           = "#F2FADE"
    case LightGray            = "#262626"
}

extension Color {
    static let fsPrimary = Color(uiColor: FSColor.primary)
    static let fsSecondary = Color(uiColor: FSColor.secondary)
    static let fsAccent = Color(red:246/255, green:252/255, blue:233/255)
    
    static let fsAccentForeground = Color(red:113/255, green:159/255, blue:17/255)
    static let fsTitle = Color(uiColor: FSColor.title)
    static let fsInputBorderColor = Color(red:230/255, green:230/255, blue:230/255)
    static let fsSubtitleColor = Color(uiColor: FSColor.subtitle)
    static let blackBackground = Color(uiColor: FSColor.blackBackground)
    static let deepBlackBackground = Color(uiColor: FSColor.deepBlackBackground)
    static let gray26 = Color(uiColor: FSColor.gray26)
    static let gray156 = Color(red:156/255, green:156/255, blue:156/255)
    static let gray246 = Color(red:246/255, green:246/255, blue:246/255)
    static let gray230 = Color(red:230/255, green:230/255, blue:230/255)
    static let calorieGreen = Color(red:113/255, green:159/255, blue:17/255)
    static let calorieGreenBG = Color(red:246/255, green:252/255, blue:233/255)
    static let carbBlue = Color(red:56/255, green:189/255, blue:248/255)
    static let carbBlueBG = Color(red:240/255, green:249/255, blue:255/255)
    static let proteinOrange = Color(red:251/255, green:146/255, blue:60/255)
    static let proteinOrangeBG = Color(red:255/255, green:247/255, blue:237/255)
    static let fatPurple = Color(red:167/255, green:139/255, blue:250/255)
    static let fatPurpleBG = Color(red:245/255, green:243/255, blue:255/255)
    static let workoutBackgroundColor = Color(red:252/255, green:252/255, blue:252/255, opacity: 255)
}
