//
//  InstructionView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import SwiftUI

struct InstructionView: View {
    let instructions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            FSText(text: "How to perform this exercise:", fontStyle: .headers20)
                .padding(.bottom, 8)

            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                    HStack(alignment: .top, spacing: 8) {
                        FSText(text: "\(index + 1).", fontStyle: .body16, color: .fsSubtitleColor)

                        FSText(text: instruction, fontStyle: .body16, color: .fsSubtitleColor)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView(instructions: [
            "Stand with feet shoulder-width apart.",
            "Bend forward slightly while keeping your back straight.",
            "Hold the stretch for the duration."
        ])
    }
}
