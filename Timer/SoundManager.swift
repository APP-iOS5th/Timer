//
//  SoundManager.swift
//  Timer
//
//  Created by 이융의 on 4/12/24.
//

import Foundation
import SwiftUI
import AVFoundation

class SoundManager: ObservableObject {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    @Published var isMuted: Bool = false
    
    func playSound() {
        guard !isMuted, let url = Bundle.main.url(forResource: "ios_17_radial", withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
    
    func stopSound() {
        player?.stop()
    }
    
    func toggleMute() {
        isMuted.toggle()
    }
}
