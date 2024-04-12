//
//  ContentView.swift
//  Timer
//
//  Created by mosi on 4/12/24.
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
    
    @State private var isRunning = false // 타이머를 클릭해서 작동중인 판단하는 변수
    @State private var isStopping = false
    @State private var timeRemaining = 0
    @State private var runString = "시작"
    @State private var pauseString = "정지"
    @State private var resetString = "리셋"
    var maxMinute  = 20
    
    //타이머 함수 1초마다 이벤트를 발생시킨다
    let timer = Timer.publish(every: 1, on: .main , in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                    .frame(width: 250, height: 250)
                
                Circle()
                // trim은 시작위치가 오른쪽 90도
                    .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat((maxMinute * 60)))
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .rotationEffect(.degrees(-90)) // -90도 돌려준다
                
                VStack(spacing: 20){
                    Text("\(String(format: "%02d", timeRemaining / 60)):\(String(format: "%02d", timeRemaining % 60))")
                        .font(.system(size: 60, weight: .light))
                        .tint(.black)
                    
                    HStack(spacing: 30){
                        Button(action: {
                            if 0 <= timeRemaining && timeRemaining <= (maxMinute-1) * 60 {
                                timeRemaining += 60
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .tint(.black)
                        }
                        Button(action: {
                            switch(timeRemaining){
                            case ..<60:
                                timeRemaining = 0
                            default :
                                timeRemaining -= 60
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .tint(.black)
                        }
                    }
                }
            }
        }
        .frame(width: 50, height: 200)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        //view에서 지정된 publisher가 emit한 데이터를 감지할 때 수행할 작업을 추가
        .onReceive(timer, perform: { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 10 {
                    NSSound.beep()
                }
            } else if isRunning {
                isRunning = false
            }
            if isStopping {
                isRunning = false
                timeRemaining = 0
                isStopping = false
            }
        })
        
        HStack(spacing: 220) {
            Button(action: {
                isStopping.toggle()
            })
            {
                Text(resetString)
                    .padding(0.0)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.gray)
                    .background(Color.black.opacity(0.2))
                    .clipShape(Circle())
            }
            Button(action: {
                isRunning.toggle()
            })
            {
                if isRunning && timeRemaining > 0 {
                    Text(pauseString)
                        .padding(0.0)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.orange)
                        .background(Color.orange.opacity(0.2))
                        .clipShape(Circle())
                } else {
                    Text(runString)
                        .padding(0.0)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.green)
                        .background(Color.green.opacity(0.2))
                        .clipShape(Circle())
                }
                
                
            }
        }
    }
    
}

#Preview {
    ContentView()
}
