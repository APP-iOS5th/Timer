//
//  ContentView.swift
//  Timer
//
//  Created by 이융의 on 4/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isRunning: Bool = false
    @State private var timeRemaining: Int = 5
    
    @State private var playSound: Bool = false
    @State private var isAlwaysOnTop: Bool = true
    @State private var isMuted: Bool = SoundManager.instance.isMuted
    @State private var showingSetTimerView = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            if playSound {
                StopSoundButtonView(playSound: $playSound, isRunning: $isRunning, timeRemaining: $timeRemaining)
            } else {
                VStack(spacing: 20) {
                    TimerDisplayView(isRunning: $isRunning, timeRemaining: $timeRemaining)
//                        .padding(.horizontal)
                    buttonView
                }
                .frame(width: 300)
                .padding()        
                .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: isAlwaysOnTop))
                .onReceive(timer) { _ in
                    timerTick()
                }
            }
        }
        .sheet(isPresented: $showingSetTimerView) {
            SetTimerView(timeRemaining: $timeRemaining) // 모달로 표시할 뷰
        }
    }
    
    private var buttonView: some View {
        VStack(spacing: 15) {
            HStack(spacing: 10) {
                // reset tutton
                Button(action: {
    //                SoundManager.instance.stopSound()
    //                playSound = false
                    isRunning = false
                    timeRemaining = 0
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                // isAlwaysOnTop button
                Button(action: {
                    isAlwaysOnTop.toggle()
                }, label: {
                    Image(systemName: isAlwaysOnTop ? "pin.fill" : "pin")
                })
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                // mute button
                Button(action: {
                    SoundManager.instance.toggleMute()
                    isMuted = SoundManager.instance.isMuted
                }) {
                    Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                // set timer button
                Button(action: {
                    showingSetTimerView = true // 모달 표시
                }) {
                    Image(systemName: "gearshape.fill")
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            HStack(spacing: 10) {
                Button(action: {
                    timeRemaining += 60
                }, label: {
                    Text("1")
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                })
                Button(action: {
                    timeRemaining += 120
                }, label: {
                    Text("2")
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                })
                Button(action: {
                    timeRemaining += 180
                }, label: {
                    Text("3")
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                })
                Button(action: {
                    timeRemaining += 300
                }, label: {
                    Text("5")
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                })

                Button(action: {
                    timeRemaining += 600
                }, label: {
                    Text("10")
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                })
            }
        }

    }
    
    private func timerTick() {
        if isRunning && timeRemaining > 0 {
            timeRemaining -= 1
            if timeRemaining == 0 {
                SoundManager.instance.playSound()
                playSound = true
            }
        } else if isRunning {
            isRunning = false
        }
    }
}

// MARK: - STOP SOUND BUTTON VIEW

struct StopSoundButtonView: View {
    @Binding var playSound: Bool
    @Binding var isRunning: Bool
    @Binding var timeRemaining: Int
    
    @State private var imageIndex = 0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        Button(action: {
            // 사운드 재생을 중지하고, 알림 상태를 false로 설정, 타이머 관련 값 초기화
            SoundManager.instance.stopSound()
            playSound = false
            isRunning = false
            timeRemaining = 0
        }) {
            if playSound {
                Image("party-parrot-page-\(imageIndex)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } else {
                Image("party-parrot-page-0")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onReceive(timer) { _ in
            if playSound {
                imageIndex = (imageIndex + 1) % 10 // 0부터 9까지 순환
            }
        }
    }
}


// MARK: - TIMER DISPLAY VIEW

struct TimerDisplayView: View {
    @Binding var isRunning: Bool
    @Binding var timeRemaining: Int
    @State private var imageIndex = 0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var showingSetTimerView = false

    var body: some View {
        VStack {
            Text(timeString(from: timeRemaining))
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)
                .onTapGesture {
                    showingSetTimerView = true
                }

            Button(action: {
                isRunning.toggle()
            }) {
                if isRunning {
                    Image("gaming-cat-page-\(imageIndex)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                } else {
                    Image("gaming-cat-page-0")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }
            .disabled(timeRemaining > 0 ? false : true)
            .scaleEffect(isRunning && timeRemaining > 0 ? 1.3 : 1)
            .animation(.easeOut, value: isRunning)
            .buttonStyle(PlainButtonStyle())
            .onReceive(timer) { _ in
                if isRunning {
                    imageIndex = (imageIndex + 1) % 10 // 0부터 9까지 순환
                }
            }
        }
        .sheet(isPresented: $showingSetTimerView) {
            SetTimerView(timeRemaining: $timeRemaining) // 모달로 표시할 뷰
        }
    }
    
    // 시, 분, 초 문자열로 변환하는 함수
    func timeString(from totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}


// MARK: - PREVIEW

#Preview {
    ContentView()
}
