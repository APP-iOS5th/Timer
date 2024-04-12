//
//  ContentView.swift
//  Timer
//
//  Created by 김형준 on 4/12/24.
//

import SwiftUI
import AVFoundation

class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "super-mario-death-sound-sound-effect", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }}
    func playSound2() {
        guard let url = Bundle.main.url(forResource: "3. 슈퍼마리오 동전먹는 소리_띠링", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
}
let soundManager = SoundManager.instance






struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 2
    @State private var totalTime = 2
    @State private var isButtonVisible = true // 버튼의 가시성 상태를 나타내는 변수
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let image = Image("choi")
    
    
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 7)
                    .frame(width: 100, height: 100)
                
                Image("cupa2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                Circle()
                
                    .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(totalTime))
                    .stroke(Color.red, lineWidth: 7)
                    .rotationEffect(.degrees(-90))
                
                VStack{
                    
                    
                }
                if timeRemaining == 0 && isButtonVisible{
                    // 이미지를 가장 위에 올립니다.
                    Button {
                        isButtonVisible.toggle()
                        soundManager.playSound2()
                        
                    }
                label: {
                    Image("gameover")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle()) // 투명 버튼 스타일
                .background(Color.clear)
                }
                else if timeRemaining == 0 && !isButtonVisible{
                    Button {
                        isButtonVisible.toggle()
                        soundManager.playSound2()
                        timeRemaining = 2
                        totalTime = 2
                    }
                label: {
                    Image("Try")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle()) // 투명 버튼 스타일
                .background(Color.clear)
                }
                
            
        }
        HStack{
            
            Button {
                switch timeRemaining {
                case 0..<60:
                    timeRemaining = 60
                    totalTime = 60
                case 60..<180:
                    timeRemaining = 180
                    totalTime = 180
                case 180..<300:
                    timeRemaining = 300
                    totalTime = 300
                case 300..<420:
                    timeRemaining = 420
                    totalTime = 420
                    
                case 300..<600:
                    timeRemaining = 600
                    totalTime = 600
                    
                case 600..<900:
                    timeRemaining = 900
                    totalTime = 900
                    
                case 900..<1200:
                    timeRemaining = 1200
                    totalTime = 1200
                    
                case 1200..<1500:
                    timeRemaining = 1500
                    totalTime = 1500
                    
                case 1500..<1800:
                    timeRemaining = 1800
                    totalTime = 1800
                    
                    
                default:
                    timeRemaining = 0
                }
            }
        label: {
            Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                .font(.system(size: 20, weight: .bold))
        }
        .buttonStyle(PlainButtonStyle())
            Button{
                isRunning.toggle()
            } label: {
                Image(systemName:  isRunning ? "pause" : "play.fill")
            }
        }
    }

        .frame(width: 100, height: 100)
        .padding()
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
            } else if isRunning {
                isRunning = false
                soundManager.playSound()
                
            }
        }
    }
}

#Preview {
    ContentView()
}
