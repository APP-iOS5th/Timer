//
//  ContentView.swift
//  Timer
//
//  Created by Jungman Bae on 4/12/24.
//

import SwiftUI
import AVFoundation

struct AlwaysOntopView: NSViewRepresentable {
    let window: NSWindow
    let isAlwaysOnTop : Bool
    
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
        guard let url = Bundle.main.url(forResource: "Beep", withExtension: "mov")
        else {return}
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류 발생. \(error.localizedDescription)")
        }
    }
}


struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    .frame(width: 150, height: 150)
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                    .stroke(Color.red, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 150, height: 150)
                
                VStack{
                    
                    Text("\(timeRemaining / 60) : \(String(format: "%02d", timeRemaining % 60))")
                        .font(.largeTitle)
                    
                    HStack{
                        Button {
                            isRunning.toggle()
                        } label: {
                            Image(systemName: isRunning ? "pause" : "play.fill")
                        }
                        Button {
                            timeRemaining = 0
                            isRunning = false
                        } label: {
                            Image(systemName: "arrow.circlepath")
                        }
                    }
                }
            }
            HStack{
                Button("10s") {
                    if timeRemaining < 1790 {
                        timeRemaining += 10
                    }
                }
                Button("30s") {
                    if timeRemaining < 1770 {
                        timeRemaining += 30
                    }
                }
                Button("60s") {
                    if timeRemaining < 1740 {
                        timeRemaining += 60
                    }
                }
            }
        }
        .frame(width: 200, height: 200)
        .padding()
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 5 {
                    NSSound.beep()
                    print(Bundle.main)
                }
            } else if isRunning{
                isRunning = false
            }
        }
    }
}

#Preview {
    ContentView()
}
