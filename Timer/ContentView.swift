//
//  ContentView.swift
//  Timer
//
//  Created by Jungman Bae on 4/12/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var isRunning = false
    @State private var maxTime = 0
    @State private var timeRemaining = 0
    @State private var timerColor: Color = .blue
    @State private var selectedTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var minutesInput = ""
    @State private var secondsInput = ""
    @State private var restBool = false
    
    var body: some View {
        VStack {
            
            ZStack {
                
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(maxTime) )
                    .stroke(timerColor, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 150, height: 150)
                
                VStack {
                    if isRunning || timeRemaining != 0{
                        Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                            .font(.system(size: 20, weight: .bold))
                            .buttonStyle(PlainButtonStyle())
                    }else{
                        // TODO: 시간 조절
                        HStack {
                            TextField("분", text: $minutesInput)
                                .onChange(of: minutesInput) { newValue in
                                        if let number = Int(newValue), (1...60).contains(number) {
                                            // 입력값이 1에서 60 사이에 있는 경우에만 업데이트
                                            self.minutesInput = "\(number)"
                                        } else if !newValue.isEmpty {
                                            // 입력값이 없거나 1에서 60 사이에 없는 경우에는 이전 값으로 되돌림
                                            self.minutesInput = String(self.minutesInput.dropLast())
                                        }
                                    }                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.center)
                                .frame(width: 50)
                                
                                
                            Text(":")
                            TextField("초", text: $secondsInput)
                                .onChange(of: secondsInput) { newValue in
                                        if let number = Int(newValue), (1...60).contains(number) {
                                            // 입력값이 1에서 60 사이에 있는 경우에만 업데이트
                                            self.secondsInput = "\(number)"
                                        } else if !newValue.isEmpty {
                                            // 입력값이 없거나 1에서 60 사이에 없는 경우에는 이전 값으로 되돌림
                                            self.secondsInput = String(self.secondsInput.dropLast())
                                        }
                                    }
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.center)
                                .frame(width: 50)
                                
                        }
                        
                    }
                    
                    HStack{
                        // MARK: -실행 버튼
                        Button {
                            if !isRunning{
                                if timeRemaining == 0{
                                    maxTime =  sumTime(min: minutesInput, sec: secondsInput)
                                    timeRemaining = sumTime(min: minutesInput, sec: secondsInput)
                                    minutesInput = ""
                                    secondsInput = ""
                                }
                            }
                            if timeRemaining != 0{
                                isRunning.toggle()
                            }
                        } label: {
                            Image(systemName: isRunning ? "pause" : "play.fill")
                        }
                        if !isRunning{
                            Button {
                                resetFunc()
                                
                            } label: {
                                Image(systemName: "goforward")
                            }
                        }
                    }
                } //:VSTACK
                
            }  //:ZSTACK
            Spacer()
                .frame(height: 30)
            HStack{
                Button{
                    if !isRunning{
                        timerSetFunc(maxtime: 60 * 3, time: 60 * 3, timeColor: .green)
                        isRunning = true
                    }
                } label: {
                    Text("Easy")
                        .font(.caption)
                }
                .background(Color.green)
                .cornerRadius(10)
                
                
                Button{
                    if !isRunning{
                        timerSetFunc(maxtime: 60 * 5, time: 60 * 5, timeColor: .yellow)
                        isRunning = true
                    }
                } label: {
                    Text("Normal")
                        .font(.caption)
                }
                .background(Color.yellow)
                .cornerRadius(10)
                
                Button{
                    if !isRunning{
                        timerSetFunc(maxtime: 60 * 10, time: 60 * 10, timeColor: .red)
                        isRunning = true
                    }
                } label: {
                    Text("Hard")
                        .font(.caption)
                }
                .background(Color.red)
                .cornerRadius(10)
                
            }
        } //:VSTACK
        .frame(width: 150, height: 200)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 10 {
                    NSSound.beep()
                }
            } else if isRunning {
                isRunning = false
            }
        }
    }
    
    // MARK: -시간 설정 함수
    func timerSetFunc(maxtime: Int, time: Int, timeColor: Color) -> Void {
        self.maxTime = maxtime
        self.timeRemaining = time
        self.timerColor = timeColor
    }
    // MARK: - 초기화 함수
    func resetFunc() {
        self.maxTime = 0
        self.timeRemaining = 0
        timerColor = .blue
        isRunning = false
    }
    // MARK: - 초 분 합치는 함수
    func sumTime(min: String, sec: String) -> (Int){
        var time = 0
        if let m = Int(min){
            time += m*60
        }
        if let s = Int(sec){
            time += s
        }
        return time
    }
}

// MARK: - 항상 앞에 놓는 코드
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

// MARK: - 소리 내기 응애
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





#Preview {
    ContentView()
}
