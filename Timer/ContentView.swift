//
//  ContentView.swift
//  Timer
//
//  Created by 차지용 on 4/12/24.
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
        }
        else {
            window.level = .normal
        }
    }
}

class SoundManger {
    static let instance = SoundManger()
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url  = Bundle.main.url(forResource: "Coin 1" , withExtension: "mp3")
        else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")//localizedDescription: 오류에 대한 발생 이유를 설명함
        }
    }
}

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 10 //타이머의 남은 시간을 추적
    @State private var choice = ""
    @State private var showAlert = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
                Picker(selection: $choice, label: Text("선택해주세요")){
                    Text("🏃🏻‍♀️").font(.system(size: 13)).tag("🏃🏻‍♀️")
                    Text("🏃🏻").font(.system(size: 13)).tag("🏃🏻")
                    Text("🐬").font(.system(size: 13)).tag("🐬")
                    Text("🦍").font(.system(size: 13)).tag("🦍")
                    Text("🐈").font(.system(size: 13)).tag("🐈")
                    Text("🐕").font(.system(size: 13)).tag("🐕")
                }
                .frame(width: 160)
            Spacer()
            Spacer()
            Spacer()
            ZStack{
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining)/(30 * 60)) //특정 부분만 남기고 나머지 부분 절단
                    .stroke(Color.gray.opacity(0.0), lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                    .overlay(Text("\(choice)").offset(y:-50).rotationEffect(.degrees(Double(timeRemaining) / (30 * 60) * 360)))
                    
                VStack {
                    Button{
                        switch timeRemaining {
                        case 0..<180:
                            timeRemaining = 180
                        case 180..<300:
                            timeRemaining = 300
                        case 300..<480:
                            timeRemaining = 480
                        case 480..<600:
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
                        Text("\(timeRemaining/60) : \(String(format: "%02d", timeRemaining % 60))")
                            .font(.system(size:20, weight: .regular))

                    }
                    .buttonStyle(.borderless)
                    
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause" : "play.fill")
                    }
                    Button{
                        timeRemaining = 0
                    }label: {
                        Text("Reset")
                    }
                }
                
            }

        }
        .frame(width: 200, height: 200)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        //타이머 동작하는 클로저
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 10 {
                    showAlert = true
                }
                if timeRemaining <= 5 {
                    NSSound.beep()
                }
            }
            else if isRunning {
                isRunning = false
            }
        }.alert(isPresented: $showAlert, content: {
            Alert(title: Text("!!!"), message: Text("10초남았습니다!!!!"),
                  dismissButton: .default(Text("OK"))
            )
        })

    }
}

#Preview {
    ContentView()
}
