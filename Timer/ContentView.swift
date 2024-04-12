//
//  ContentView.swift
//  Timer
//
//  Created by Jungman Bae on 4/12/24.
//  Updated by Youngwoo Ahn on 4/12/24.
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
            print("Sound Complete")
        } catch let error {
            print("Sound Error :  \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    @State private var animeIconPositionX: CGFloat = -20
    @State private var animeIconName: String = "airplane"
    
    // Timer Config
    private let MAX_TIME = 11 * 60
    private let MIN_TIME = 0
    private let TIMER_VALUE = 10
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    func plusButtonActionCheckMaxTime() {
        if(timeRemaining > MAX_TIME - TIMER_VALUE) {
            timeRemaining = MAX_TIME
        } else {
            timeRemaining += TIMER_VALUE
        }
        animeIconName = "airplane"
        animeIconPositionX = -20
    }
    
    func minusButtonActionCheckMinTime() {
        if(timeRemaining < (MIN_TIME + TIMER_VALUE)) {
            timeRemaining = MIN_TIME
            print("Minus Button : \(timeRemaining)")
        } else {
            timeRemaining -= TIMER_VALUE
        }
        animeIconName = "airplane"
        animeIconPositionX = -20
    }
    
    func timerAction() {
        if isRunning && timeRemaining > 0 {
            timeRemaining -= 1
            if timeRemaining <= 10 {
                NSSound.beep()
                animeIconName = "airplane.arrival"
                print("Receive : \(timeRemaining)")
                
            }
            
            animeIconPositionX += 2
            
            if animeIconPositionX >= 20 {
                animeIconName = "airplane"
                animeIconPositionX = -20
            }
        } else if isRunning {
            isRunning = false
            animeIconName = "airplane"
            animeIconPositionX = -20
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(MAX_TIME))
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 100, height: 100)
                
                VStack{
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                        .font(.system(size: 20, weight: .bold))
                    Image(systemName: "square.fill")
                        .resizable()
                        .frame(width: 60, height: 2)
                        .offset(y:-2)
                        
                    Image(systemName: animeIconName)
                        .offset(x: animeIconPositionX, y: 0)
                        .animation(.linear(duration: 1.5), value: animeIconPositionX)
                }
            }
        }
        
        .padding()
        HStack {
            Button {
                isRunning.toggle()
            } label: {
                Image(systemName: isRunning ? "pause" : "play")
            }
            Button {
                plusButtonActionCheckMaxTime()
            } label: {
                Image(systemName: "plus")
            }
            Button {
                minusButtonActionCheckMinTime()
            } label: {
                Image(systemName: "minus")
            }
        }
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        .onReceive(timer) { _ in
            timerAction()
        }
    }
}

#Preview {
    ContentView()
}
