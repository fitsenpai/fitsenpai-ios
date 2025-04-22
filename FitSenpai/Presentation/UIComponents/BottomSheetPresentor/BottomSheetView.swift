//
//  BottomSheetView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/13/24.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isPresented: Bool
    
    var buttonConfig: FSActionButtonConfig?
    var content: Content

    // State for offset
    @State private var offsetY: CGFloat = UIScreen.main.bounds.height
    // State to track the computed height
    @State private var computedHeight: CGFloat = 0

    init(isPresented: Binding<Bool>, buttonConfig: FSActionButtonConfig? = nil, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
        self.buttonConfig = buttonConfig
    }

    var body: some View {
        ZStack {
            // Tap outside to dismiss
            if isPresented {
                Color.black.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismissSheet()
                    }
            }
            VStack {
                Spacer()
                VStack {
                    // Handle bar at the top
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.grey227)
                        .frame(width: 40, height: 4)
                        .padding(.top, 8)

                    // Main Content
                    content
                        .padding(.top, buttonConfig == nil ? 16 : 5)
                        

                    // Optional Button
                    if let buttonConfig = buttonConfig {
                        FSButton(title: buttonConfig.title, tapAction: {
                            dismissSheet()
                            buttonConfig.action()
                        })
                    }
                }
                .padding([.leading, .trailing], 16)
                .padding(.bottom, UIApplication.shared.bottomSafeAreaInset)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedCornerShape(corners: [.topLeft, .topRight], radius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                )
                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                .offset(y: offsetY) // Bind to offset state
                .animation(.easeOut(duration: 0.3), value: offsetY) // Smooth animation
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                offsetY = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > computedHeight / 2 {
                                dismissSheet()
                            }else{
                                withAnimation {
                                    offsetY = 0
                                }
                            }
                        }
                )
                .onAppear(perform: {
                    withAnimation {
                        offsetY = 0
                    }
                })
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        // Capture the computed height when the view appears
                        let safeAreaBottom = UIApplication.shared.bottomSafeAreaInset
                        computedHeight = geometry.size.height + safeAreaBottom
                        print("Computed height: \(computedHeight)") // Debug print to ensure correct height
                    }
                    .onChange(of: computedHeight, { _, _ in
                        offsetY = 0
                    })
                })
            }
            .edgesIgnoringSafeArea(.bottom)
            
        }
    }

    private func dismissSheet() {
        withAnimation {
            offsetY = UIScreen.main.bounds.height // Slide the sheet off the screen
            isPresented = false
        }
    }
}

// Preview with different content examples
struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            BottomSheetView(isPresented: .constant(true), buttonConfig: FSActionButtonConfig(title: "Submit feedback", action: {})) {
                FeedbackView(comment: "Let us know your thoughts on today’s meals. Mention what you enjoyed or what you’d like changed.")
            }
        }
        .previewLayout(.sizeThatFits)
        
    }
}
