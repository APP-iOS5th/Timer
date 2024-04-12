//
//  ContentView.swift
//  Timer
//
//  Created by Jungman Bae on 4/12/24.
//

import SwiftUI



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




struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    
    
    func resetB() {
        timeRemaining = 0}
    
    func increment() {
        timeRemaining += 10
    }
    
    func decrement() {
        if timeRemaining <= 9 {
            return timeRemaining = 0
        } else {
            timeRemaining -= 10}}
        

            
            
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 15)
                    .frame(width:230, height: 230)

                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    .frame(width:230, height: 230)

                VStack {
                    
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))").font(.system(size: 30, weight: .bold))
                    
                    
                    HStack{
                        VStack{
                            Button {
                                isRunning.toggle()
                            } label: {
                                Image(systemName: isRunning ? "pause" : "play.fill")
                                Text("Start/Stop")}
                            Button {
                                resetB()
                            } label: {
                                Image(systemName: isRunning ? "stop.circle.fill" : "stop.circle.fill")
                                Text("r e    s e t")
                            }
                            
                            
                        }
                        VStack{
                            VStack {
                                Button {
                                    increment()
                                } label: {
                                    Image(systemName: isRunning ? "plus.circle.fill" : "plus.circle.fill")
                                    Text("+10sec")
                                }
                                
                            }
                            VStack{
                                Button {
                                    decrement()
                                } label: {
                                    Image(systemName: isRunning ? "minus.circle.fill" : "minus.circle.fill")
                                    Text("-10sec")
                                }
                                
                            }
                            
                        }
                    }
                }
            }
            
        }
        .frame(width: 250, height: 250)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                
            } else if isRunning {
                isRunning = false
            }
        }
    }
}

#Preview {
    ContentView()
}
