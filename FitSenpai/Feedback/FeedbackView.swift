//
//  FeedbackView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/13/24.
//

import SwiftUI

struct FeedbackView: View {
    @State var comment: String
    
    var smileyStack: some View {
        HStack(spacing: 16) {
            Image("ic_smiley_sad")
                .resizable()
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray230, lineWidth: 1)
                }
                .frame(width: 64, height: 64)
            
            Image("ic_smiley_meh")
                .resizable()
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray230, lineWidth: 1)
                }
                .frame(width: 64, height: 64)
            
            Image("ic_smiley_smiley")
                .resizable()
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray230, lineWidth: 1)
                }
                .frame(width: 64, height: 64)
                
        }
    }
    
    var textField: some View {
        VStack(alignment: .leading, spacing: 6){
            FSText (text: "Additional comments(optional)", fontStyle: .medium16)
            TextEditor(text: $comment)
                .font(.body14)
                .foregroundColor(Color.fsSubtitleColor)
                .onChange(of: comment, { oldValue, newValue in
                    //
                })
                .padding(.leading, -5)
                .clipped()
                .opacity(comment.isEmpty ? 0.1 : 1)
                .dynamicTypeSize(.large)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray230, lineWidth: 1)
                }
                .frame(height: 88)
            
        }
    }
    
    var body: some View {
        VStack (spacing: 20) {
            VStack(spacing: 16) {
                VStack {
                    FSText(text: "How was your meal", fontStyle: .headers)
                    FSText(text: "experience?", fontStyle: .headers)
                }
                
                smileyStack
                textField
            }
            
        }
        .padding(16)
    }
}

#Preview {
    FeedbackView(comment: "Hello")
}
