//
//  ContentView.swift
//  Timer
//
//  Created by JIHYE SEOK on 4/12/24.
//

import SwiftUI
import AVFoundation

// 항상 윗쪽 배치
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

// 소리음 삽입
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
    @State private var isPlay = false
    @State private var timeRemaining = 30
    @State private var minutesInput = 0
    @State private var secondsInput = 0
    @State private var totalTime = 30
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private func getBarColor() -> Color {
        let progress = Double(timeRemaining) / Double(totalTime)
        if progress > 0.5 {
            return .green
        } else if progress > 0.2 {
            return .yellow
        } else {
            return .red
        }
    }
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Image(systemName: "battery.0percent")
                    .resizable()
                    .frame(width: 120, height: 60)
                
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(getBarColor())
                    .frame(width: (88.5 * CGFloat(timeRemaining) / CGFloat(totalTime)), height: 40)
                    .offset(x: 8.5, y: -1.5)
                
                Text("\(String(format: "%02d", timeRemaining / 60)):\(String(format: "%02d", timeRemaining % 60))")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .offset(x: -7)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    
            }
            
            HStack {
                TextField("M", value: $minutesInput, formatter: NumberFormatter())
                    .frame(width: 30, alignment: .center)
                    .textFieldStyle(SquareBorderTextFieldStyle())
                    .font(.title2)
                    .fontWeight(.bold)
                    
                
                Text(":")
                    .font(.title2)
                    .fontWeight(.bold)
                
                TextField("S", value: $secondsInput, formatter: NumberFormatter())
                    .frame(width: 30, alignment: .center)
                    .textFieldStyle(SquareBorderTextFieldStyle())
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Button {
                timeRemaining = minutesInput * 60 + secondsInput
                totalTime = timeRemaining
                isPlay.toggle()
            } label: {
                Image(systemName: isPlay ? "pause" : "play.fill")
            }
            .buttonStyle(PlainButtonStyle())
            .font(.system(size: 30))
            .disabled(Int(minutesInput) < 0 || Int(secondsInput) <= 0)
            
        }
        .padding()
        .frame(width: 150, height: 150)
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        .onReceive(timer) { _ in
            if isPlay && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 10 {
                    NSSound.beep()
                }
            } else if isPlay {
                isPlay = false
            }
        }
    }
}

#Preview {
    ContentView()
}
