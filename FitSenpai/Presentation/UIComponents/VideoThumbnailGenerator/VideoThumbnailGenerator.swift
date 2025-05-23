//
//  VideoThumbnailGenerator.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/18/24.
//

import Kingfisher
import SwiftUI
import AVFoundation
import CryptoKit

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
    @State private var internalIsLoading: Bool = true
    @State private var thumbnailImageURL: URL? = nil
    @State private var didAttemptLoad: Bool = false

    var body: some View {
        VStack {
            if internalIsLoading || thumbnailImageURL == nil && !didAttemptLoad {
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
            internalIsLoading = true
            didAttemptLoad = false
            performInitialLoad()
        }
    }
    
    private func performInitialLoad() {
        if let existingThumbnail = thumbnailImageURL, videoURL == self.videoURL {
             if self.internalIsLoading {
                 self.internalIsLoading = false
             }
             self.didAttemptLoad = true
             return
        }

        if !self.internalIsLoading {
             self.internalIsLoading = true
        }
        self.didAttemptLoad = false
        generateThumbnailAndCache(from: self.videoURL)
    }

    private func generateThumbnailAndCache(from url: URL) {
        if let cachedThumbnailURL = getCachedThumbnailURL(for: url) {
            self.thumbnailImageURL = cachedThumbnailURL
            self.internalIsLoading = false
            self.didAttemptLoad = true
        } else {
            if !self.internalIsLoading { self.internalIsLoading = true }
            VideoThumbnailGenerator.generateThumbnail(from: url) { thumbnail in
                if let thumbnail = thumbnail {
                    if let cachedImageURL = self.saveThumbnailToCache(thumbnail, for: url) {
                        self.thumbnailImageURL = cachedImageURL
                    } else {
                        print("VideoPreviewView: Failed to save thumbnail to cache for \(url)")
                    }
                } else {
                    print("VideoPreviewView: Thumbnail generation failed for \(url)")
                }
                self.internalIsLoading = false
                self.didAttemptLoad = true
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
                print("Failed to save image to cache: \(error)")
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
