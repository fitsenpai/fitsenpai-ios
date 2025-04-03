//
//  FSImageView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation
import SwiftUI
import AVKit
import Kingfisher

struct FSImageView: View {
    var url: URL?
    var radius: CGFloat = 0
    var placeHolder: String?

    @State private var aspectRatio: CGFloat = 1.0 // Default aspect ratio

    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width
            let _ = containerWidth / aspectRatio

            Group {
                if let url = url {
                    if url.pathExtension == "mp4" {
                        VideoPlayerView(videoURL: url, aspectRatio: $aspectRatio)
//                            .frame(width: containerWidth, height: computedHeight)
                    } else {
                        KFImage(url)
                            .placeholder {
                                Image(placeHolder ?? "")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .onSuccess { result in
                                let size = result.image.size
                                aspectRatio = size.width / size.height // Update aspect ratio
                            }
                            .resizable()
                            .scaledToFill()
                            /*.frame(width: containerWidth, height: computedHeight)*/ // Explicitly set dimensions
                    }
                } else {
                    Image(placeHolder ?? "")
                        .resizable()
                        .scaledToFill()
                        /*.frame(width: containerWidth, height: computedHeight)*/ // Explicitly set dimensions
                }
            }
            .cornerRadius(radius)
            .clipped()
        }
        //.aspectRatio(1.0, contentMode: .fit) // Ensures proportional sizing
    }
}

struct VideoPlayerView: View {
    var videoURL: URL
    @Binding var aspectRatio: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width
            let _ = containerWidth / aspectRatio

            VideoPlayer(player: AVPlayer(url: videoURL))
//                .aspectRatio(containerWidth / computedHeight, contentMode: .fit)
//                .frame(width: containerWidth, height: computedHeight)
                // Explicitly set frame
                .onAppear {
                    fetchVideoAspectRatio(for: videoURL) { ratio in
                        aspectRatio = ratio
                    }
                }
        }
    }

    private func fetchVideoAspectRatio(for url: URL, completion: @escaping (CGFloat) -> Void) {
        let asset = AVAsset(url: url)
        
        Task {
            do {
                let tracks = try await asset.loadTracks(withMediaType: .video)
                guard let track = tracks.first else { return }
                
                let size = try await track.load(.naturalSize)
                let transform = try await track.load(.preferredTransform)
                let adjustedSize = size.applying(transform)
                
                let ratio = abs(adjustedSize.width) / abs(adjustedSize.height)
                await MainActor.run {
                    completion(ratio)
                }
            } catch {
                print("Error loading video track: \(error)")
            }
        }
    }
}

struct FSImageView_Previews: PreviewProvider {
    static var previews: some View {
//        FSImageView(url: URL(string: "https://txvhbjocxiodvtqreskj.supabase.co/storage/v1/object/public/workouts/abdominals/decline_bench_oblique_crunches_bodyweight.mp4?"))
        FSImageView(url: nil, placeHolder: "img_meal")
    }
}
