//
//  GenericTextListView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import SwiftUI

struct GenericTextListView: View {
    let title: String
    let instructions: [String]
    let isNumbered: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            FSText(text: title, fontStyle: .medium16)
                .padding(.bottom, 8)

            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                    HStack(alignment: .top, spacing: 8) {
                        FSText(text: isNumbered ? "\(index + 1)." : "•", fontStyle: .body14, color: .black)
                        FSText(text: instruction, fontStyle: .body14, color: .black, lineSpacing: 6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        GenericTextListView(title: "How to perform this exercise:", instructions: [
            "Stand with feet shoulder-width.",
            "Bend forward slightly while keeping",
            "Hold the stretch for the duration."
        ], isNumbered: false)
    }
}
