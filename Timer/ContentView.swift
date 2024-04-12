//
//  ContentView.swift
//  Timer
//
//  Created by Jungjin Park on 2024-04-12.
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
            window.backgroundColor = .clear
        } else {
            window.level = .normal
        }
    }
}
struct ContentView: View {
    @State private var initialMinutes = 1
    @State private var remainingSeconds = 5
    @State private var isRunning = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speech(_ speak: String) {
        let utterance = AVSpeechUtterance(string: speak)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        self.speechSynthesizer.speak(utterance)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: CGFloat(remainingSeconds) / (CGFloat(initialMinutes) * 60))
                    .stroke(Color.red, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    
                VStack {
                    Text("\(remainingSeconds / 60) : \(String(format: "%02d", remainingSeconds % 60))")
                        .font(.system(size: 20, weight: .bold))
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause" : "play.fill")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.system(size: 20, weight: .bold))
                    Picker("", selection: $initialMinutes, content: {
                        if isRunning {
                            Text("Running").tag("")
                        } else {
                            ForEach([1,2,3,4,5,6,7,8,9,10,15,20,25,30,35,40,45,50,55,60], id:\.self) {
                                Text("\($0)")
                            }
                        }
                    })
                    .frame(width: 60)
                    .pickerStyle(.menu)
                    .onChange(of: initialMinutes) { oldValue, newValue in
                        remainingSeconds = initialMinutes * 60
                    }
                    .padding(.trailing, 6)
                }
            }
        }
        .frame(width: 100, height: 100)
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        .onReceive(timer) { _ in
            if isRunning && remainingSeconds > 0 {
                remainingSeconds -= 1
            }
            if remainingSeconds < 4 && remainingSeconds > 0 {
                speech("\(remainingSeconds)")
            }
            if remainingSeconds == 0 && isRunning {
                speech("Stop")
                remainingSeconds = initialMinutes * 60
                isRunning = false
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
