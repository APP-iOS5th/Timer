//
//  ContentView.swift
//  TIMER_T
//
//  Created by Mac on 4/12/24.
//

import SwiftUI
import AVFoundation




struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 10
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2),lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
               
                VStack {
                    Buttton {
                        
                    } label: {
                        Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                            .font(.system(size: 20, weight: .bold))
                    }
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause" : "play.fill")
                          //  .buttonStyle(PlainButtonStyle())
                    }
                }
                
            }
            
        }
        .frame(width: 100, height: 100)
        .padding()
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 10 {
                    NSSound.beep()
                }
                
            } else if isRunning {
                isRunning = false
                NSSound.beep()
            }
        }
    }
}

#Preview {
    ContentView()
}
