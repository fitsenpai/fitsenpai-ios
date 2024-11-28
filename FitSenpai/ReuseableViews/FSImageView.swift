//
//  FSImageView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation
import Kingfisher
import SwiftUI

struct FSImageView: View {
    var url: URL?
    var width: CGFloat?
    var height: CGFloat?
    var radius:CGFloat = 0
    var placeHolder: String?
    
    var body: some View {
        KFImage.url(url)
            .placeholder({
                Image(placeHolder ?? "")
                    .resizable()
            })
            .fade(duration: 0.25)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
            .cornerRadius(radius)
            .clipped()
            
    }
}
