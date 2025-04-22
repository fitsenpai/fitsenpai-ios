//
//  RoundedCorner.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import Foundation
import UIKit
import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    var borderWidth: CGFloat = 0
    var borderColor: Color = .clear

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let borderPath = path.cgPath
        
        var combinedPath = Path()
        combinedPath.addPath(Path(borderPath))
        
        return combinedPath
    }
    
    func stroke(lineWidth: CGFloat = 1, color: Color = .black) -> some View {
        self.stroke(color, lineWidth: lineWidth)
    }
}
