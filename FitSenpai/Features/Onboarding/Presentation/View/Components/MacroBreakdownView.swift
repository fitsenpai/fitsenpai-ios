//
//  MacroBreakdownView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI

struct MacroBreakdownView: View {
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                FSText(text: "Your personalized macro breakdown", fontStyle: .heading28, alignment: .center)
                FSText(text: "Based on your profile, here's what your body needs to reach your goal", fontStyle: .body16, alignment: .center)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 40)
            
            HStack(spacing: 16) {
                MacroItem(value: "\(calories)", label: "Calories", color: .fsAccentForeground, icon: "ic_calorie")
                MacroItem(value: "\(protein)g", label: "Protein", color: .fsOrange400, icon: "ic_bone_orange")
            }
            
            HStack(spacing: 16) {
                MacroItem(value: "\(carbs)g", label: "Carbs", color: .fsSky400, icon: "ic_carbs")
                MacroItem(value: "\(fat)g", label: "Fat", color: .fsViolet400, icon: "ic_fat")
            }
            Spacer()
        }
    }
}

struct MacroItem: View {
    let value: String
    let label: String
    let color: Color
    let icon: String
    
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                FSText(text: value, fontStyle: .bodyBold28, color: color)

                HStack(spacing: 4) {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                    
                    FSText(text: label, fontStyle: .body12, color: .black)
                }
            }
        }
        .frame(width: 132, height: 132)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
