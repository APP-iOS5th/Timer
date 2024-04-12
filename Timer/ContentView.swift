//
//  ContentView.swift
//  Timer
//
//  Created by mosi on 4/12/24.
//

import SwiftUI
import AppKit
import AVFoundation



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
    
    @State private var isRunning = false // 타이머를 클릭해서 작동중인지 판단하는 변수
    @State private var timeRemaining = 10
    
    //타이머 함수 1초마다 이벤트를 발생시킨다
    let timer = Timer.publish(every: 1, on: .main , in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                
                Circle()
                    // trim은 시작위치가 오른쪽 90도
                    .trim(from: 0, to: CGFloat(timeRemaining) / (5 * 60))
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90)) // -90도 돌려준다
                 
                VStack{
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
                    }label:{ Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                    .font(.system(size: 20, weight: .bold))
                }.buttonStyle(PlainButtonStyle())
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                    }
                }
            }
        }
        .frame(width: 100, height: 100)
        .padding()
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
        })
    }
}

#Preview {
    ContentView()
}
