//
//  ContentView.swift
//  Timer
//
//  Created by uunwon on 4/12/24.
//

import SwiftUI

@available(iOS 15.0, *)
struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 100
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.customPink.opacity(0.9), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                        .font(.system(size: 20, weight: .bold))
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause" : "play.fill")
                            .imageScale(.large)
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
