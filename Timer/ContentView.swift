//
//  ContentView.swift
//  Timer
//
//  Created by 이융의 on 4/12/24.
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
        guard let url = Bundle.main.url(forResource: "ios_17_radial", withExtension: "mp3") else { return }
        
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
    @State private var timeRemaining = 5
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                    .stroke(Color.blue, lineWidth: 10)
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
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause" : "play.fill")
                    }
                }
            }
                
        }
        .frame(width: 100, height: 100)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 0 {
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


// timeremaining 을 설정할 때, circle drag gesture 로 추가하도록 변경.
// 버튼 애니메이션 설정. 혹은, 거북이가 걸어가거나 돌아가는 애니메이션도 괜찮다
// 아이폰 기본 알람음 사용 (radiar ?)
// 상단 고정 기능과 소리 음소거 온오프기능을을 설정 버튼으로 지정하기
// window 창의 타이머 제목.

// 함수별로 기능을 잘 정렬하는 것도 중요
