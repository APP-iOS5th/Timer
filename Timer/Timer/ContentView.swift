//
//  ContentView.swift
//  Timer
//
//  Created by uunwon on 4/12/24.
//

import SwiftUI
import AVFoundation


// ❤️‍🩹 Navigation Stack 도전 . . -> 배경 이슈로 보류
struct TimerView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.pink.opacity(0.8), lineWidth: 1.5)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                    .stroke(Color.white, lineWidth: 1.5)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Button {
                        switch timeRemaining {
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
                            .foregroundStyle(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .imageScale(.large)
                            .foregroundColor(.pink)
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

// ✨ 항상 위에 떠있게 하는 struct
struct AlwaysOnTopView: NSViewRepresentable {
    let window: NSWindow
    let isAlwaysOnTop: Bool
    
    func makeNSView(context: Context) -> some NSView {
        let view = NSView()
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        if isAlwaysOnTop {
            window.level = .floating
        } else {
            window.level = .normal
        }
    }
}

// ✨ 소리 넣기
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

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Timer")
                .font(.system(size: 8))
                .padding(.bottom, 3.0)
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color.customOrange.opacity(0.5), lineWidth: 1.2)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                    .stroke(Color.white.opacity(0.5), lineWidth: 1.2)
                    .rotationEffect(.degrees(-90))
                
                Button {
                    switch timeRemaining {
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
                    Image("egg")
                        .resizable()
                        .frame(width: 85, height: 85)
                }
                .buttonStyle(.borderless)
            }
            
            Spacer()
            
            Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                .font(.system(size: 10))
            
            Button {
                isRunning.toggle()
            } label: {
                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                    .imageScale(.small)
            }
            .buttonStyle(.borderless)
        }
        .frame(width: 100, height: 150)
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
