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
            FSTextView(title, typography: .p_ui_medium)
                .padding(.bottom, 8)

            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                    HStack(alignment: .top, spacing: 8) {
                        FSTextView(isNumbered ? "\(index + 1)." : "•", typography: .body)
                        FSTextView(instruction, typography: .body)
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
