//
//  ContentView.swift
//  Timer
//
//  Created by 육현서 on 4/12/24.
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
    var backgroundPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "background", withExtension: "mp3") else { return }
        
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = -1 // 반복 재생
            backgroundPlayer?.play()
        } catch let error {
            print("배경음악 재생 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
    }
}

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 60
    @State private var imageName = "sponge"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
                .clipped()
            
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.cyan.opacity(0.5), lineWidth: 10)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                        .stroke(Color.yellow, lineWidth: 10)
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Button {
                            switch timeRemaining {
                            case 0..<60:
                                timeRemaining = 60
                            case 0..<180:
                                timeRemaining = 180
                            case 180..<300:
                                timeRemaining = 300
                            case 300..<420:
                                timeRemaining = 420
                            case 300..<600:
                                timeRemaining = 600
                            case 600..<900:
                                timeRemaining = 900
                            case 900..<1200:
                                timeRemaining = 1200
                            case 1200..<1500:
                                timeRemaining = 1500
                            case 1500..<1800:
                                timeRemaining = 1800
                            default:
                                timeRemaining = 0
                            }
                            
                        } label: {
                            Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .buttonStyle(PlainButtonStyle())
                        Button {
                            isRunning.toggle()
                            if isRunning {
                                SoundManager.instance.playBackgroundMusic()
                            } else {
                                SoundManager.instance.stopBackgroundMusic()
                            }
                        } label: {
                            Image(systemName: isRunning ? "pause" : "play.fill")
                        }
                    }
                }
            }
            .frame(width: 200, height: 200)
            .padding()
            .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
            .onReceive(timer) { _ in
                if isRunning && timeRemaining > 0 {
                    timeRemaining -= 1
                } else if isRunning {
                    isRunning = false
                    SoundManager.instance.stopBackgroundMusic() // 타이머가 종료되면 배경음악 중지
                }
                
                // 타이머에 따른 이미지 변경
                if timeRemaining == 0 && imageName == "sponge" {
                    imageName = "wakesponge"
                } else if timeRemaining != 0 && imageName == "wakesponge" {
                    imageName = "sponge"
                }
            }
        }

    // 자동 음악 재생
//        .onAppear {
//            SoundManager.instance.playBackgroundMusic()
//        }
    }
}


#Preview {
    ContentView()
}
