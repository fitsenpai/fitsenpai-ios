//
//  RoundedBorderTextField.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/21/24.
//

import SwiftUI

struct RoundedBorderTextField: View {
    @Binding var text: String
    var label: String = ""
    var placeholder: String = ""
    var isSecure: Bool = false
    var showAccessory: Bool = false
    var height: CGFloat = 44
    var cornerRadius: CGFloat = 6.0
    var errorMessage: String? = nil
    var isValid: Bool = true
    
    @State private var isInputHidden: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            FSText(text: label, fontStyle: .body16, color: .fsTitle)
            
            HStack {
                if isSecure && isInputHidden {
                    SecureField(placeholder, text: $text)
                        .padding(.horizontal)
                        .frame(height: height)
                } else {
                    TextField(placeholder, text: $text)
                        .padding(.horizontal)
                        .frame(height: height)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                }
                
                if showAccessory {
                    Button(action: {
                        isInputHidden.toggle()
                    }) {
                        Image(systemName: isInputHidden ? "eye.slash" : "eye")
                            .foregroundColor(.fsMutedForeground)
                    }
                    .padding(.trailing)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isValid ? Color.fsInputBorderColor : Color.red, lineWidth: isValid ? 1 : 2)
            )
            
            // Error message
            if let errorMessage = errorMessage, !isValid {
                FSText(text: errorMessage, fontStyle: .caption2, color: .red)
                    .padding(.leading, 4)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        RoundedBorderTextField(
            text: .constant(""), 
            label: "Email", 
            isSecure: true, 
            showAccessory: true
        )
        
        RoundedBorderTextField(
            text: .constant(""), 
            label: "Password", 
            isSecure: true, 
            showAccessory: true,
            errorMessage: "Password must be at least 8 characters",
            isValid: false
        )
    }
    .padding()
}
