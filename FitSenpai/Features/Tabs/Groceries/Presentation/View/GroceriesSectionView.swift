//
//  GroceriesSectionView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/12/24.
//

import SwiftUI

struct GroceriesSectionView: View {
    @State var selectedItems: [FoodItem]
    @State var foodCategory: FoodCategory
    @State var foodItems: [FoodItem]
    @State var isShowingDetails: Bool

   
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    withAnimation(.easeInOut) {
                        isShowingDetails.toggle()
                    }
                } label: {
                    HStack {
                        ZStack(alignment: .center) {
                            RoundedCornerShape(corners: .allCorners, radius: 6)
                                .frame(width: 28, height: 28)
                                .foregroundColor(Color.gray246)
                            Image(foodCategory.imageName())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        }
                        
                        FSText(text: foodCategory.title(), fontStyle: .body14, color: .fsTitle)
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut) {
                                isShowingDetails.toggle()
                            }
                        }, label: {
                            Image("ic_chevron_right")
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
                        ForEach(foodItems, id: \.self) { item in
                            CheckboxLabelView(
                                title: item.name,
                                detailInfo: item.amount,
                                isChecked: selectedItems.contains { $0.name == item.name },
                                onItemSelected: {
                                    selectedItems.append(item)
                                },
                                onItemDeselected: {
                                    selectedItems.removeAll { $0.name == item.name }
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

#Preview {
    GroceriesSectionView(selectedItems: [], foodCategory: .proteins, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
}
