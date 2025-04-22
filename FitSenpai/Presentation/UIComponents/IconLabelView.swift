//
//  IconLabelView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/23/24.
//

import SwiftUI

struct IconLabelView: View {
    var fsMetric: FSMetric
    var value: Int
    var typography: FSTypography
    var fontColor: Color
    var iconSize: CGFloat
    var spacing: CGFloat = 4
    var showBorder: Bool = false
    var width: CGFloat?
    var isFullWidth: Bool = false
    
    var body: some View {
        HStack(spacing: spacing) {
            Image(fsMetric.getInfoForIcon(value).iconName)
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .scaledToFit()
            FSTextView(fsMetric.getInfoForIcon(value).description, typography: typography, color: fontColor)
        }
        .if(isFullWidth) { view in
            view.frame(maxWidth: .infinity)
        }
        .if(showBorder) { view in
            view
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray230, lineWidth: 1)
                    .frame(height: 40)
                    .if(width != nil) { v in
                            v.frame(width: width!)
                    }
                    
                    
            }
        }
        
    }
}

