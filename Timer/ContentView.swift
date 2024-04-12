//
//  ContentView.swift
//  Timer
//
//  Created by 황규상 on 4/12/24.
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
    var startEndDivision = ""
    
    func playSound(division soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
}

struct AlwaysOnTopToggle: View {
    @Binding var isAlwaysOnTop: Bool
    let window: NSWindow
    
    var body: some View {
        Toggle("Always on Top", isOn: $isAlwaysOnTop)
            .onChange(of: isAlwaysOnTop) { _, newValue in
                window.level = newValue ? .floating : .normal
            }
    }
}

struct DifficultyButton: View {
    let label: String
    let time: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .frame(width: 60, height: 30, alignment: .center)
                .foregroundColor(.white)
                .background(isSelected ? Color.red : Color.blue)
                .cornerRadius(25)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    @State private var isAlwaysOnTop = false
    @State private var selectedButton: String?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private func startTimer(time: Int) {
        timeRemaining = time
        isRunning = true
    }
    
    var body: some View {
        HStack {
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 30)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                        .stroke(Color.blue, lineWidth: 30)
                        .rotationEffect(.degrees(-90))
                    
                    Button {
                        isRunning.toggle()
                        SoundManager.instance.playSound(division: "startPractice")
                    } label: {
                        Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.system(size: 51))
                    .foregroundColor(isRunning ? .red : .green)
                }
                .frame(width: 80, height: 80)
                
                HStack {
                    Button {
                        if timeRemaining == 0 || !isRunning {
                            switch timeRemaining {
                            case 0..<60:
                                timeRemaining = 60
                            case 0..<120:
                                timeRemaining = 120
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
                        }
                    } label: {
                        Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                            .font(.system(size: 20, weight: .bold))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 25)
                    
                    Button {
                        timeRemaining = 0
                        isRunning = false
                    } label: {
                        Image(systemName: isRunning || (timeRemaining != 0) ? "gobackward" : "")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.system(size: 15, weight: .bold))
                    .padding(.top, 25)
                }
                
                Toggle("Always on Top", isOn: $isAlwaysOnTop)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                    .padding(.top, 10)
                    .frame(width: 200, height: 10)
                
                HStack {
                    DifficultyButton(
                        label: "Easy",
                        time: 180,
                        isSelected: selectedButton == "Easy",
                        action: {
                            startTimer(time: 180)
                            selectedButton = "Easy"
                    })
                    DifficultyButton(
                        label: "Soso",
                        time: 300,
                        isSelected: selectedButton == "Soso",
                        action: {
                            startTimer(time: 300)
                            selectedButton = "Soso"
                    })
                    DifficultyButton(
                        label: "Hard",
                        time: 600,
                        isSelected: selectedButton == "Hard",
                        action: {
                            startTimer(time: 600)
                            selectedButton = "Hard"
                    })
                }
                .padding(.top, 20)
                
            }
            .frame(width: 110, height: 110)
            .padding()
            .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: isAlwaysOnTop))
            .onReceive(timer) { _ in
                if isRunning && timeRemaining > 0 {
                    timeRemaining -= 1
                    if timeRemaining <= 10 {
                        NSSound.beep()
                    }
                } else if isRunning {
                    SoundManager.instance.playSound(division: "endPractice")
                    isRunning = false
                }
            }
            .frame(width: 130, height: 130)
        }
        .frame(width: 250, height: 300)
    }
}

#Preview {
    ContentView()
}
