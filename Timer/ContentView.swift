//
//  ContentView.swift
//  Timer
//
//  Created by 장예진 on 4/12/24.
////
////원형안에 글씨넣을라고 원형을 만듦
import SwiftUI
import AVFoundation

//소리 부분 클래스

class SoundPlayer: ObservableObject {
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "congratulations", withExtension: "mp3") else {
            print("Sound file not found.")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Couldn't load sound file: \(error)")
        }
    }
}

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    @State private var scale: CGFloat = 1.0
    
    @ObservedObject var soundPlayer = SoundPlayer()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            ZStack {
                //기존 두깨보다 두껍게 해서 디자인 안정성 더함? ㅋ 내생각
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / 600)
                    .stroke(Color.green, lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                        .font(.system(size: 30, weight: .semibold))
                        .scaleEffect(scale)
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            isRunning.toggle()
                        }) {
                            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                        }
                        .font(.headline)
                        
                        //실습시간에 많이 사용했던 시간을 메뉴로 추가해줌
                        Menu("Add") {
                            Button("1 Minute") { addTime(minutes: 1) }
                            Button("3 Minutes") { addTime(minutes: 3) }
                            Button("5 Minutes") { addTime(minutes: 5) }
                            Button("10 Minutes") { addTime(minutes: 10) }
                        }
                        .frame(width: 70, height: 50)
                        .font(.title)
                    }
                }
            }
        }
        .frame(width: 200, height: 200)
        .padding()
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
            } else if timeRemaining == 0 && isRunning {
                isRunning = false
                soundPlayer.playSound()
                animateText()
            }
        }
    }

    func addTime(minutes: Int) {
        timeRemaining += minutes * 60
    }
    
    func animateText() {
        withAnimation(.easeInOut(duration: 1.0)) {
            scale = 1.5
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 1.0)) {
                scale = 1.0
            }
        }
    }
}


#Preview {
    ContentView()
}
