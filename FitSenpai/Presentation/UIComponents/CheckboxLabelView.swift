//
//  CheckboxLabelView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/12/24.
//

import SwiftUI

struct CheckboxLabelView: View {
    
    @State var title: String
    @State var detailInfo: String
    @State var isChecked = false
    
    var onItemSelected: FSEmptyCallback?
    var onItemDeselected: FSEmptyCallback?
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                isChecked.toggle()
                
                if isChecked {
                    onItemSelected?()
                } else {
                    onItemDeselected?()
                }
            }, label: {
                if isChecked {
                    Image("ic_checkbox_selected")
                        .resizable()
                        .frame(width: 29, height: 29)
                }else{
                    Image("ic_checkbox_unselected")
                        .resizable()
                        .frame(width: 29, height: 29)
                }
            })
            
            FSTextView(title, typography: .body, color: .fsMutedForeground)
            
            Spacer()
            
            /// Change to dots temporarily
            /// FSTextView(detailInfo, typography: .body, color: .fsMutedForeground.opacity(0.8))
            
            Image(.iconDots)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    CheckboxLabelView(title: "Grilled chicken", detailInfo: "750g")
}
