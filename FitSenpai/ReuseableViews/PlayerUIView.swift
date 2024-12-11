//
//  PlayerUIView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import Foundation
import UIKit
import AVKit
import SwiftUI

class PlayerUIView: UIView {
    
    // MARK: Class Property
    
    let playerLayer = AVPlayerLayer()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(player: AVPlayer) {
        super.init(frame: .zero)
        self.playerSetup(player: player)
        self.loopVideo(videoPlayer: player)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Life-Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
        
    }
    
    // MARK: Class Methods
    
    private func playerSetup(player: AVPlayer) {
        playerLayer.player = player
        player.actionAtItemEnd = .none
        layer.addSublayer(playerLayer)
        playerLayer.backgroundColor = UIColor(red:252/255, green:252/255, blue:252/255, alpha: 255).cgColor //UIColor(hexString: "#fcfcfc").cgColor
    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: .zero)
            videoPlayer.play()
        }
    }
}


struct PlayerView: UIViewRepresentable {
    
    @Binding var player: AVPlayer
    
    func makeUIView(context: Context) -> PlayerUIView {
        return PlayerUIView(player: player)
    }
    
    func updateUIView(_ uiView: PlayerUIView, context: UIViewRepresentableContext<PlayerView>) {
        uiView.playerLayer.player = player
    }
}



