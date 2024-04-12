//
//  ContentView.swift
//  Timer
//
//  Created by Yachae on 4/12/24.
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = 1 // 빨간불일 때 한번씩
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
}


struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    @State private var isRed = false // 빨간불
    @State private var sliderValue: Double = 0 // 슬라이더
    let totalTime = 900.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            Color.red
                .opacity(isRed ? 0.5 : 0)
                .animation(.easeInOut(duration: 0.5), value: isRed)
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / (15 * 60))
                        .stroke(Color.blue, lineWidth: 10)
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Button {
                            let timeIntervals = Array(stride(from: 0, through: 900, by: 60))
                            for (_, time) in timeIntervals.enumerated() {
                                if timeRemaining < time {
                                    timeRemaining = time
                                    break
                                } else if timeRemaining >= timeIntervals.last! {
                                    timeRemaining = 0
                                    break
                                }
                            }
                        } label: {
                            Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .buttonStyle(PlainButtonStyle())
                        Button {
                            isRunning.toggle()
                            if isRunning && timeRemaining <= 5 {
                                isRed = true // 재생을 누르고, 5초 이하면 빨간색 활성화
                                SoundManager.instance.playSound()
                            } else {
                                isRed = false // 그 외의 경우 빨간색 비활성화
                                SoundManager.instance.player?.stop()
                            }
                        } label: {
                            Image(systemName: isRunning ? "pause" : "play.fill")
                        }
                    }
                    
                }
                .frame(width: 150, height: 150)
                .padding()
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5.0)
                        .frame(width: 200, height: 20)
                        .foregroundColor(Color.gray.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: 5.0)
                        .frame(width: max(CGFloat(sliderValue / totalTime) * 200, 0), height: 20)
                        .foregroundColor(sliderValue <= 5 ? Color.red : Color.blue) // 5초 이하일 때 빨간색으로 변경
                        .animation(.linear, value: sliderValue)
                    Slider(value: $sliderValue, in: 0...totalTime, step: 1)
                        .padding()
                        .frame(width: 200)
                        .onChange(of: sliderValue) { [sliderValue] in
                            timeRemaining = Int(sliderValue)
                        }
                }
                .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
                .onReceive(timer) { _ in
                    if isRunning && timeRemaining > 0 {
                        timeRemaining -= 1
                        sliderValue = Double(timeRemaining)
                        
                        if timeRemaining <= 5 { // 타이머가 5초 이하일때만 AlwaysOnTop
                            isRed.toggle()
                            NSApplication.shared.windows.first?.level = .floating
                            if isRed {
                                SoundManager.instance.playSound()
                            } else {
                                SoundManager.instance.player?.stop()
                            }
                            
                        } else {
                            NSApplication.shared.windows.first?.level = .normal
                            SoundManager.instance.player?.stop()
                        }
                    } else if isRunning {
                        isRunning = false
                        isRed = false
                        SoundManager.instance.player?.stop()
                    }
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
