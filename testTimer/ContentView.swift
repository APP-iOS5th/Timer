//
//  ContentView.swift
//  testTimer
//
//  Created by wonyoul heo on 4/12/24.
//

import SwiftUI
import AVFoundation

struct AlwaysOntopView: NSViewRepresentable {
    let window: NSWindow
    let isAlwaysOnTop : Bool
    
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
        guard let url = Bundle.main.url(forResource: "Beep", withExtension: "mov")
        else {return}
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류 발생. \(error.localizedDescription)")
        }
    }
}


struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                    .stroke(Color.red, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                
                VStack{
                    Button {
                        switch timeRemaining {
                        case 0..<180:
                            timeRemaining = 180
                        case 180..<300:
                            timeRemaining = 300
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
                        Text("\(timeRemaining / 60) : \(String(format: "%02d", timeRemaining % 60))")
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
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 5 {
                    NSSound.beep()
                    print(Bundle.main)
                }
            } else if isRunning{
                isRunning = false
            }
        }
    }
}

#Preview {
    ContentView()
}


//timeRemaining / 60 >> 60으로 나눈 몫
//String(format: "%02d", timeRemaining % 60) >> 60으로 나눈 나머지를 2자리 숫자로 포맷한다. (2자리의 정수)
///Users/wonyoulheo/Library/Developer/Xcode/DerivedData/testTimer-dhxwlqdonlzkztcbmqjhnenuqiob/Build/Intermediates.noindex/Previews/testTimer/Products/Debug/testTimer.app
