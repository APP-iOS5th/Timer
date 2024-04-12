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
    @State private var addTime1 = 1
    @State private var addTime2 = 5
    @State private var reduceTime = 1
    @State private var flag = false
    @State private var myColor = Color.gray.opacity(0.2)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let soundManager = SoundManager.instance
    
    var body: some View {
        VStack {
            ZStack {
                //버튼 시간 조정하기
                Button(action: {
                    flag.toggle()
                }, label: {
                    Text(flag ? "완 료" : "버튼 수정")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 45)
                })
                .padding(5)
                .foregroundColor(.blue)
                .background(Color.white)
                .cornerRadius(10.0)
                .offset(CGSize(width: -95.0, height: -65.0))
                
                
                // 가운데 타이머 원
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
                // 거북이
                VStack {
                    Image(systemName: "tortoise.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .scaleEffect(x: -1, y: 1)
                        .offset(CGSize(width: 00.0, height: -10.0))
                    Spacer()
                }
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(totalTime != 0 ? Double(timeRemaining) / Double(totalTime) * 360 : 0.0))
                
                // 시간 추가, 감소 버튼
                VStack(spacing: 10) {
                    Button {
                        timeRemaining += addTime1 * 60
                        totalTime += addTime1 * 60
                    } label: {
                        VStack{
                            Image(systemName: "timer.square")
                                .font(.title)
                            if flag {
                                Stepper(value: $addTime1, in: 1...10) {
                                    Text("+\(addTime1)m")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                            }
                            else {
                                Text("+\(addTime1)m")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    Button {
                        timeRemaining += addTime2 * 60
                        totalTime += addTime2 * 60
                    } label: {
                        VStack{
                            Image(systemName: "timer.square")
                                .font(.title)
                            if flag {
                                Stepper(value: $addTime2, in: 5...60, step: 5) {
                                    Text("+\(addTime2)m")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                            }
                            else {
                                Text("+\(addTime2)m")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    Button {
                        if timeRemaining >= reduceTime * 60 {
                            timeRemaining -= reduceTime * 60
                            totalTime -= reduceTime * 60
                        }
                    } label: {
                        VStack{
                            Image(systemName: "timer.square")
                                .font(.title)
                            if flag {
                                Stepper(value: $reduceTime, in: 1...60) {
                                    Text("-\(reduceTime)m")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                            }
                            else {
                                Text("-\(reduceTime)m")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                        }.foregroundColor(.red)
                    }
                }
                .offset(CGSize(width: 100.0, height: 00.0))
            }
            // 재생, 정지 버튼
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
            .offset(CGSize(width: 0.0, height: flag ? -3.5 : 10.0))
            .frame(width: 100)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 230, height: 170)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: isRunning ? true : false))
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 10 {
                    NSSound.beep()
                }
            } else if isRunning {
                isRunning = false
                totalTime = 0
                soundManager.playSound()
            }
        }
    }
}

#Preview {
    ContentView()
}
