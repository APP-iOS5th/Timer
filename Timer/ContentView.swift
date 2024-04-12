//
//  ContentView.swift
//  Timer
//
//  Created by 조성빈 on 4/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isRunning = false
    @State private var timeRemaining = 0
    @State private var defaultTime = 0
    
    // every 마다 이벤트를 발생시킴
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(defaultTime))
                    .stroke(
                        CGFloat(timeRemaining) / CGFloat(defaultTime) > 0.66 ? .green : CGFloat(timeRemaining) / CGFloat(defaultTime) > 0.33 ? .orange : .red
                        , lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    .animation(Animation.linear(duration: 1), value: timeRemaining)
                Button(action: {
                    timeRemaining += 10
                    defaultTime += 10
                }) {
                    Image(systemName: "10.circle")
                        .font(.system(size: 25))
                }
                .buttonStyle(PlainButtonStyle())
                .position(x: 7, y: 7)
                VStack(spacing: 10) {
                    Text("\(String(format: "%02d", timeRemaining / 60)) : \(String(format: "%02d", timeRemaining % 60))")
                        .font(.system(size: 35, weight: .bold))
                    HStack(spacing: 13) {
                        Button(action: {
                            timeRemaining += 60
                            defaultTime += 60
                        }) {
                            Text("1분")
                        }
                        Button(action: {
                            timeRemaining += 300
                            defaultTime += 300
                        }) {
                            Text("5분")
                        }
                        Button(action: {
                            timeRemaining += 600
                            defaultTime += 600
                        }) {
                            Text("10분")
                        }
                    }
                    HStack(spacing: 20) {
                        Button(action: {
                            isRunning.toggle()
                        }) {
                            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                .font(.system(size: 30))
                        }
                        .disabled(timeRemaining > 0 ? false : true)
                        .buttonStyle(PlainButtonStyle())
                        Button(action: {
                            isRunning = false
                            timeRemaining = 0
                            defaultTime = 0
                        }) {
                            Image(systemName: "square.fill")
                                .font(.system(size: 25))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.top, 10)
                }
            }
            .frame(width: 200, height: 200)
            .padding()
            .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
            .onReceive(timer) { _ in
                if isRunning && timeRemaining > 0 {
                    timeRemaining -= 1
                }else if isRunning {
                    isRunning = false
                    defaultTime = 0
                    NSSound.beep()
                }
            }
        }
    }
}

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

#Preview {
    ContentView()
}
