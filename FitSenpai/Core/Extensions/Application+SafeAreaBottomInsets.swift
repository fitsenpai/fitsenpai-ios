//
//  Application+SafeAreaBottomInsets.swift
//  FitSenpai
//
//  Created by Kevin M on 12/21/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    var bottomSafeAreaInset: CGFloat {
        return connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .safeAreaInsets.bottom ?? 0
    }
}
