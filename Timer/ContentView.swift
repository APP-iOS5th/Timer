//
//  ContentView.swift
//  Timer
//
//  Created by 황승혜 on 4/12/24.
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
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    @State private var stateSymbol = "" // 선택한 시간에 따라 출력되는 심볼
    //@State private var alertColor
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        VStack {
            
            ZStack {

                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10) //기본 틀
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                    .stroke(Color.purple, lineWidth: 10)
                    .rotationEffect(.degrees(-90))

                
                VStack (){
                    Spacer()
                    Spacer()
                    Button {
                        switch timeRemaining {
                        case 0..<180:
                            timeRemaining = 180
                            stateSymbol = "figure.walk"
                        case 180..<300:
                            timeRemaining = 300
                            stateSymbol = "figure.walk"
                        case 300..<420:
                            timeRemaining = 420
                            stateSymbol = "bicycle"
                        case 420..<600:
                            timeRemaining = 600
                            stateSymbol = "bicycle"
                        case 600..<900:
                            timeRemaining = 900
                            stateSymbol = "car.fill"
                        case 900..<1200:
                            timeRemaining = 1200
                            stateSymbol = "car.fill"
                        case 1200..<1500:
                            timeRemaining = 1500
                            stateSymbol = "train.side.front.car"
                        case 1500..<1800:
                            timeRemaining = 1800
                            stateSymbol = "train.side.front.car"
                        default:
                            timeRemaining = 0
                            stateSymbol = ""
                        }
                    } label: {
                        Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                            .font(.system(size: 20, weight: .bold))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(-10)
                
                   
                    Image(systemName: stateSymbol)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(6)
                        .scaleEffect((timeRemaining <= 10 && timeRemaining % 2 == 0) ? 1.75 : 1) //10초 이하일 때 크기 변경
                        .animation(.default, value: timeRemaining)
                    
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause" : "play.fill")
                            .font(.system(size: 15, weight: .bold))
                    } .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
        }
        .frame(width: 100, height: 100)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        .onReceive(timer) { _ in //타이머가 실행되면 뒤의 코드를 실행
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 10 {
                    NSSound.beep()
                }
            } else if isRunning {
                isRunning = false
                SoundManager.instance.playSound()
            }
        }
    }
}

#Preview {
    ContentView()
}
