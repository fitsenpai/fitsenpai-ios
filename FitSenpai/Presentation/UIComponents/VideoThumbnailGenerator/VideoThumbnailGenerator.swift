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
    @State private var thumbnailImageURL: URL? = nil 
    @State private var didAttemptLoad: Bool = false

    var body: some View {
        VStack {
            if isLoading || thumbnailImageURL == nil && !didAttemptLoad {
                ShimmerView(cornerRadius: 8)
                    .frame(width: 80, height: 80)
            } else if let finalThumbnailURL = thumbnailImageURL {
                ZStack {
                    KFImage(finalThumbnailURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(4)

                    Color.black.opacity(0.1)
                        .cornerRadius(4)

                    Image("ic_play")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.white)
                }
                .frame(width: 80, height: 80)
            } else {
                ZStack {
                    Color.gray.opacity(0.1)
                        .cornerRadius(4)
                    
                    Button {
                        performInitialLoad()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 80, height: 80)
            }
        }
        .onAppear {
            performInitialLoad()
        }
        .onChange(of: videoURL) { _, newURL in
            thumbnailImageURL = nil 
            performInitialLoad()
        }
    }
    
    private func performInitialLoad() {
        if let existingThumbnail = thumbnailImageURL, videoURL == self.videoURL {
             if self.isLoading { 
                 DispatchQueue.main.async { self.isLoading = false }
             }
             self.didAttemptLoad = true
             return
        }

        if !self.isLoading {
            DispatchQueue.main.async { self.isLoading = true }
        }
        self.didAttemptLoad = false 
        generateThumbnailAndCache(from: self.videoURL) 
    }

    private func generateThumbnailAndCache(from url: URL) {
        FSLogger.debug("VideoPreviewView: generateThumbnailAndCache for \(url)")
        if let cachedThumbnailURL = getCachedThumbnailURL(for: url) {
            FSLogger.debug("VideoPreviewView: Found cached thumbnail for \(url) at \(cachedThumbnailURL)")
            self.thumbnailImageURL = cachedThumbnailURL
            DispatchQueue.main.async {
                self.isLoading = false // Update binding
                self.didAttemptLoad = true
            }
        } else {
            FSLogger.debug("VideoPreviewView: No cache, generating thumbnail for \(url)")
            VideoThumbnailGenerator.generateThumbnail(from: url) { thumbnail in 
                if let thumbnail = thumbnail {
                    FSLogger.debug("VideoPreviewView: Thumbnail generated for \(url)")
                    if let cachedImageURL = self.saveThumbnailToCache(thumbnail, for: url) {
                        FSLogger.debug("VideoPreviewView: Thumbnail cached for \(url) at \(cachedImageURL)")
                        self.thumbnailImageURL = cachedImageURL
                    } else {
                        FSLogger.error("VideoPreviewView: Failed to save thumbnail to cache for \(url)")
                    }
                } else {
                    FSLogger.error("VideoPreviewView: Thumbnail generation failed for \(url)")
                }
                DispatchQueue.main.async {
                    self.isLoading = false // Update binding
                    self.didAttemptLoad = true
                }
            }
        }
    }

    private func saveThumbnailToCache(_ image: UIImage, for videoURL: URL) -> URL? { 
        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let videoHash = videoURL.absoluteString.data(using: .utf8)?.md5().hexString() ?? UUID().uuidString
        let thumbnailFilename = "\(videoHash).jpg"
        let finalThumbnailURL = cacheDirectory.appendingPathComponent(thumbnailFilename)
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: finalThumbnailURL)
                return finalThumbnailURL
            } catch {
            }
        }
        return nil
    }

    private func getCachedThumbnailURL(for videoURL: URL) -> URL? {
        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let videoHash = videoURL.absoluteString.data(using: .utf8)?.md5().hexString() ?? UUID().uuidString
        let thumbnailFilename = "\(videoHash).jpg"
        let thumbnailCacheURL = cacheDirectory.appendingPathComponent(thumbnailFilename)
        
        if fileManager.fileExists(atPath: thumbnailCacheURL.path) {
            return thumbnailCacheURL
        }
        return nil
    }
}

import CryptoKit

extension Data {
    func md5() -> Insecure.MD5.Digest {
        return Insecure.MD5.hash(data: self)
    }
}

extension Insecure.MD5.Digest {
    func hexString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
