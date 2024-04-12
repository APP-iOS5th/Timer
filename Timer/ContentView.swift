//
//  ContentView.swift
//  Timer
//
//  Created by Jungman Bae on 4/12/24.
//

import SwiftUI
import AVFoundation


struct AlwaysOnTopView: NSViewRepresentable {
    let window: NSWindow
    let isAlwaysOnTop: Bool
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        if isAlwaysOnTop {
            window.level = .floating
        } else {
            window.level = .normal
        }
    }
}


class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Beep", withExtension: "mov") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다 \(error.localizedDescription)")
        }
    }
}


struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (10 * 60))
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                        Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                            .font(.system(size: 20, weight: .bold))
                            .offset(x:0, y: 25)
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause" : "play.fill")
                    }
                    .offset(x: 0, y:25)
                    
                    Button {
                        switch timeRemaining {
                        case 0..<60:
                            timeRemaining = 60
                        case 60..<120:
                            timeRemaining = 120
                        case 120..<180:
                            timeRemaining = 180
                        case 180..<240:
                            timeRemaining = 240
                        case 240..<300:
                            timeRemaining = 300
                        case 300..<360:
                            timeRemaining = 360
                        case 360..<420:
                            timeRemaining = 420
                        case 420..<480:
                            timeRemaining = 480
                        case 480..<540:
                            timeRemaining = 540
                        case 540..<600:
                            timeRemaining = 600
                        default:
                            timeRemaining = 0
                        }
                    } label: {
                        Image(systemName: "plus.square.fill")
                    }
                    .buttonStyle(.borderless)
                    .offset(x: 50, y: -70)
                    
                    Button {
                        switch timeRemaining {
                        case 540..<600:
                            timeRemaining = 540
                        case 480..<540:
                            timeRemaining = 480
                        case 420..<480:
                            timeRemaining = 420
                        case 360..<420:
                            timeRemaining = 360
                        case 300..<360:
                            timeRemaining = 300
                        case 240..<300:
                            timeRemaining = 240
                        case 180..<240:
                            timeRemaining = 180
                        case 120..<180:
                            timeRemaining = 120
                        case 60..<120:
                            timeRemaining = 60
                        case 0..<60:
                            timeRemaining = 0
                        default:
                            timeRemaining = 0
                        }
                    } label: {
                        Image(systemName: "minus.square.fill")
                    }
                    .buttonStyle(.borderless)
                    .offset(x: 50, y: 6)
                }
            }
                
        }
        .frame(width: 100, height: 100)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
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
