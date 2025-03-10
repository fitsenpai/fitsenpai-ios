//
//  SelectableIconLabelView.swift
//  FitSenpai
//
//  Created by Kevin M on 3/10/25.
//

import SwiftUI

struct SelectableIconLabelView: View {
    @State var isSelected: Bool = false
    @State var title: String
    @State var subtitle: String?
    @State var iconName: String
    
    let iconSize:CGFloat = 20
    var spacing: CGFloat = 17
    var width: CGFloat?
    
    var body: some View {
        HStack(spacing: spacing) {
            Image(iconName)
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .scaledToFit()
                .background {
                    Circle()
                        .fill(isSelected ? Color.gray246 : Color.white)
                        .frame(width: 40, height: 40)
                }
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 10) {
                FSText(text: title, fontStyle: isSelected ? .bodyBold16 : .body16, color: .blackBackground)
                if let subtitle = subtitle {
                    FSText(text: subtitle, fontStyle: .body10, color: .blackBackground)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill (isSelected ? Color.white: Color.gray246)
                .if(isSelected) { view in
                    view.stroke(Color.fsPrimary, lineWidth: 1.5)
                }
                
        }
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

#Preview {
    SelectableIconLabelView(title: "Sedentary", subtitle: "Mostly sitting, little exercise", iconName: "ic_chair")
}
