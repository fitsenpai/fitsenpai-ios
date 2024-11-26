//
//  FSButtonLight.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import SwiftUI

struct FSButtonLight: View {
    var title: String
    var tapAction: FSAction
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            FSText(text: title, fontStyle: .body16, letterSpace: 1.5, color: .fsTitle)
                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                .foregroundColor(.white)
                .background(Color.fsSecondary)
                .clipShape(RoundedCorner(radius: 6))
        }

    }
}

#Preview {
    FSButtonLight(title: "Sign Up", tapAction: {})
}
