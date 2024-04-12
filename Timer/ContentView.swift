//
//  ContentView.swift
//  Timer
//
//  Created by Jungman Bae on 4/12/24.
//

import SwiftUI
import AVFoundation
import Combine

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
    @State private var minuteInput = ""
    @State private var secondInput = ""
    @State private var positionX: CGFloat = 0
    @State private var isRotated = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (60 * 60))
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                
                GeometryReader { geometry in
                    VStack {
                        Image(systemName: "hare.fill")
                            .offset(x: positionX)
                            .onChange(of: isRunning) { oldValue, newValue in
                                if newValue {
                                    withAnimation(Animation.linear(duration: 4).repeatForever()) {
                                        positionX = CGFloat(geometry.frame(in: .global).origin.x) * (-1)
                                        positionX += geometry.size.width
                                    }
                                } 

                            }
                    }
                }
                
                VStack {
                    HStack {
                        TextField("00", text: $minuteInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 40)
                            .onReceive(Just(minuteInput)) {
                                let filteredMinute = $0.filter { "0123456789".contains($0) }
                                if filteredMinute != $0 {
                                    minuteInput = filteredMinute
                                }

                                if let minute = Int(minuteInput), minute > 59 {
                                    minuteInput = "59"
                                }
                            }
                            .onChange(of: minuteInput) { oldValue, newValue in
                                let minute = Int(newValue) ?? 0
                                timeRemaining = minute * 60 + (Int(secondInput) ?? 0)
                            }
                        Text(":")
                        TextField("00", text: $secondInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 40)
                            .onReceive(Just(secondInput)) {
                                let filteredSecond = $0.filter { "0123456789".contains($0) }
                                if filteredSecond != $0 {
                                    secondInput = filteredSecond
                                }
                                
                                if let second = Int(secondInput), second > 59 {
                                    secondInput = "59"
                                }
                            }
                            .onChange(of: secondInput) { oldValue, newValue in
                                let second = Int(newValue) ?? 0
                                timeRemaining = (Int(minuteInput) ?? 0) * 60 + second
                            }
                    }
                    .padding()
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause" : "play.fill")
                    }
                }
            }

        }
        .frame(width: 150, height: 150)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                minuteInput = String(timeRemaining / 60)
                secondInput = String(format: "%02d", timeRemaining % 60)
                
                if timeRemaining <= 10 {
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
