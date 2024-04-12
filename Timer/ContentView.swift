//
//  ContentView.swift
//  Timer
//
//  Created by mini on 2024/04/12.
//

import SwiftUI

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 100
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                VStack {
                    Text("\(timeRemaining / 60): \(String(format: "%02d", timeRemaining % 60))")
                        .font(.system(size: 20, weight: .bold))
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause" : "play.fill")
                    }
                }
                
            }
        }
        .frame(width: 100, height: 100)
        .padding()
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
