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
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
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
        
    }
}

#Preview {
    ContentView()
}
