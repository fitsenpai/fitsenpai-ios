//
//  VideoThumbnailGenerator.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/18/24.
//

import Kingfisher
import SwiftUI
import AVFoundation

class VideoThumbnailGenerator {
    static func generateThumbnail(from url: URL, atTime time: CMTime = CMTimeMake(value: 1, timescale: 2), completion: @escaping (UIImage?) -> Void) {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

struct VideoPreviewView: View {
    let videoURL: URL
    @Binding var isLoading: Bool
    @State private var thumbnailURL: URL? = nil
    @State private var onRefresh: Bool = true
    
    var body: some View {
        VStack {
            if isLoading {
                ShimmerView(cornerRadius: 8)
                    .frame(width: 80, height: 80)
            } else {
                ZStack {
                    if let thumbnailURL, onRefresh {
                        KFImage(thumbnailURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(.rect(cornerRadius: 10))
                            .shadow(radius: 10)
                        
                        Color.black.opacity(0.1)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        
                        // When not loading, show the play icon
                        Image("ic_play")
                            .resizable()
                            .frame(width: 12, height: 12)
                        
                    } else {
                        Color.gray.opacity(0.1)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        
                        Button {
                            isLoading = true
                            generateThumbnailAndCache(from: videoURL)
                        } label: {
                            Image(.icArrows)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.white)
                        }
                    }
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        .onAppear {
            // Generate and cache thumbnail from the video URL
            generateThumbnailAndCache(from: videoURL)
        }
    }

    // Function to generate and cache the thumbnail image
    private func generateThumbnailAndCache(from videoURL: URL) {
        // First, check if the thumbnail already exists in the cache
        if let cachedThumbnailURL = getCachedThumbnailURL(for: videoURL) {
            // If thumbnail is cached, use that
            self.thumbnailURL = cachedThumbnailURL
            self.isLoading = false
        } else {
            // Otherwise, generate a new thumbnail and cache it
            VideoThumbnailGenerator.generateThumbnail(from: videoURL) { thumbnail in
                if let thumbnail = thumbnail {
                    // Save the thumbnail using Kingfisher and update the state
                    let cachedImageURL = saveThumbnailToCache(thumbnail)
                    self.thumbnailURL = cachedImageURL
                    self.isLoading = false
                } else {
                    self.isLoading = false
                }
            }
        }
    }

    // Function to save the thumbnail image to a local file and return its URL for caching
    private func saveThumbnailToCache(_ image: UIImage) -> URL? {
        // Create a unique filename for the thumbnail
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let thumbnailURL = cacheDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: thumbnailURL)
                return thumbnailURL
            } catch {
                print("Failed to save image to cache: \(error)")
            }
        }
        return nil
    }

    // Function to get the cached thumbnail URL based on the video URL
    private func getCachedThumbnailURL(for videoURL: URL) -> URL? {
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        // We can base the cache on a hash of the video URL or its unique identifier
        let videoHash = videoURL.absoluteString.hash
        let thumbnailCacheURL = cacheDirectory.appendingPathComponent("\(videoHash).jpg")
        
        if fileManager.fileExists(atPath: thumbnailCacheURL.path) {
            return thumbnailCacheURL
        }
        return nil
    }
}
