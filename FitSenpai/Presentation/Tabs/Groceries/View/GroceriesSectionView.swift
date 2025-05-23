//
//  GroceriesSectionView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/12/24.
//

import SwiftUI

struct GroceriesSectionView: View {
    @Binding var shoppingCategory: ShoppingCategory
    @State private var isShowingDetails: Bool = false

    var category: FoodCategory {
        let category = FoodCategory(rawValue: shoppingCategory.category)
        return category
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    withAnimation(.easeInOut) {
                        isShowingDetails.toggle()
                    }
                    triggerHaptics()
                } label: {
                    HStack {
                        ZStack(alignment: .center) {
                            RoundedCornerShape(corners: .allCorners, radius: 6)
                                .frame(width: 28, height: 28)
                                .foregroundColor(Color.gray246)
                            Image(category.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        }
                        FSTextView("\(category.title) (\(shoppingCategory.items.count))", typography: .body_medium)

                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut) {
                                isShowingDetails.toggle()
                            }
                        }, label: {
                            Image(.icChevronRight)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .rotationEffect(.degrees(isShowingDetails ? 90 : 0))
                                .animation(.easeInOut, value: isShowingDetails)
                        })
                    }
                    .background(.white)
                }

                // Animated details section
                if isShowingDetails {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach($shoppingCategory.items) { $item in
                            CheckboxLabelView(
                                title: item.name,
                                detailInfo: item.estimatedPrice,
                                isChecked: item.isSelected,
                                onItemSelected: {
                                    triggerHaptics()
                                    item.isSelected = true
                                },
                                onItemDeselected: {
                                    triggerHaptics()
                                    item.isSelected = false
                                }
                            )
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.95, anchor: .top).combined(with: .opacity),
                        removal: .scale(scale: 0.95, anchor: .top).combined(with: .opacity)
                    ))
                }
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray230, lineWidth: 1)
            }
            .zIndex(1)
        }
    }
}
