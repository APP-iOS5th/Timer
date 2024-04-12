//
//  ContentView.swift
//  Timer
//
//  Created by 김영훈 on 4/12/24.
//

import SwiftUI
import AVFoundation

struct AlwaysOnTopView: NSViewRepresentable {
    let window: NSWindow
    let isAlwaysOnTop: Bool
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView ()
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
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
}


struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    @State private var totalTime = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(totalTime))
                        .stroke(Color.blue, lineWidth: 10)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 100, height: 100)
                    
                    
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                        .font(.system(size: 20, weight: .bold))
                    
                    VStack(spacing: 10) {
                        Button {
                            timeRemaining += 60
                            totalTime += 60
                        } label: {
                            VStack{
                                Image(systemName: "timer.square")
                                    .font(.title)
                                Text("+1m")
                                    .font(.subheadline)
                            }
                        }
                        Button {
                            timeRemaining += 180
                            totalTime += 180
                        } label: {
                            VStack{
                                Image(systemName: "timer.square")
                                    .font(.title)
                                Text("+3m")
                                    .font(.subheadline)
                            }
                        }
                        Button {
                            timeRemaining += 300
                            totalTime += 180
                        } label: {
                            VStack{
                                Image(systemName: "timer.square")
                                    .font(.title)
                                Text("+5m")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .offset(CGSize(width: 100.0, height: 00.0))
                }
                
            
            .offset(CGSize(width: 0.0, height: 0.0))
            HStack {
                Button {
                    isRunning.toggle()
                } label: {
                    Image(systemName: isRunning ? "pause" : "play.fill")
                        .font(.title)
                }
                Spacer()
                Button {
                    isRunning = false
                    timeRemaining = 0
                    totalTime = 0
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.title)
                }
            }
            .offset(CGSize(width: 0.0, height: 10.0))
            .frame(width: 100)
            
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 230, height: 170)
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
                totalTime = 0
            }
        }
    }
}

#Preview {
    ContentView()
}
