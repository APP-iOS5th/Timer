//
//  ContentView.swift
//  Timer
//
//  Created by uunwon on 4/12/24.
//

import SwiftUI
import AVFoundation

class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Beep", withExtension: "mov") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
}

@available(iOS 15.0, *)
struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 5
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.customPink.opacity(0.9), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (5 * 60))
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                        .font(.system(size: 20, weight: .bold))
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .imageScale(.large)
                    }
                }
            }
        }
        .frame(width: 100, height: 100)
        .padding()
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 10 {
                    NSSound.beep()
                }
            } else if isRunning {
                isRunning = false
            }
        }
    }
}

#Preview {
    ContentView()
}
