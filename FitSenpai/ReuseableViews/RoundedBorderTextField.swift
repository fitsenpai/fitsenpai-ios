//
//  RoundedBorderTextField.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/21/24.
//

import SwiftUI

struct RoundedBorderTextField: View {
    @Binding var text: String
    var placeholder: String = ""
    var isSecure: Bool = false
    var showAccessory: Bool = false
    
    @State private var isInputHidden: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            FSText(text: placeholder, fontStyle: .fieldsHeader, color: .fsTitle)
            
            HStack {
                if isSecure && isInputHidden {
                    SecureField("", text: $text)
                        .padding(.horizontal)
                        .frame(height: 44)
                } else {
                    TextField("", text: $text)
                        .padding(.horizontal)
                        .frame(height: 44)
                }
                
                if showAccessory {
                    Button(action: {
                        isInputHidden.toggle()
                    }) {
                        Image(systemName: isInputHidden ? "eye.slash" : "eye")
                            .foregroundColor(.fsSubtitleColor)
                    }
                    .padding(.trailing)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.fsInputBorderColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
    RoundedBorderTextField(text: .constant(""), placeholder: "Email", isSecure: true, showAccessory: true)
}
