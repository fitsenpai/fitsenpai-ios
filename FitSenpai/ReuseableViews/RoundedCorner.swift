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

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
