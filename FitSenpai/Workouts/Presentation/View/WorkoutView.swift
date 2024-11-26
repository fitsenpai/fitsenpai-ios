//
//  WorkoutView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/23/24.
//

import SwiftUI

struct WorkoutView: View {
    var image: String
    var title: String
    @State var isSelected: Bool
    @State var showInfo: Bool
    
    var horizontalInfoView: some View  {
        HStack {
            IconLabelView(fsMetric: .WorkoutSet, value: 4, fontStyle: .body12, fontColor: .fsSubtitleColor, iconSize: 12)
            
            IconLabelView(fsMetric: .WorkoutRep, value: 12, fontStyle: .body12, fontColor: .fsSubtitleColor, iconSize: 12)
            
            IconLabelView(fsMetric: .WorkoutWeight, value: 10, fontStyle: .body12, fontColor: .fsSubtitleColor, iconSize: 12)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray230, lineWidth: 1)
            HStack(alignment: .center) {
                HStack(spacing: 12) {
                    ZStack {
                        Image(image)
                            .resizable()
                        Color.black.opacity(0.3)
                        Image("ic_play")
                            .resizable()
                            .frame(width: 11, height: 13)
                        
                        
                    }
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    VStack(alignment: .leading, spacing: 10 ) {
                        FSText(text: title, fontStyle: .medium16, color: .fsTitle)
                        if showInfo {
                            horizontalInfoView
                                .ignoresSafeArea()
                        }
                    }
                }
                Spacer()
                
                Button(action: {
                    isSelected.toggle()
                }, label: {
                    if isSelected {
                        Image("ic_checkbox_selected")
                            .resizable()
                            .frame(width: 29, height: 29)
                    }else{
                        Image("ic_checkbox_unselected")
                            .resizable()
                            .frame(width: 26, height: 26)
                    }
                })
                
            }
            .padding(12)
        }
    }
}

#Preview {
    WorkoutView(image: "ic_workout", title: "Bench press", isSelected: false, showInfo: true)
}
