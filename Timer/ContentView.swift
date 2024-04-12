//
//  ContentView.swift
//  Timer
//
//  Created by SeongKook on 4/12/24.
//

import SwiftUI
import AVFoundation



struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaing = 300
    @State private var showingModal = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaing) / (30 * 60))
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    
                
                VStack{
                    
                    Button {
                        showingModal = true
                    } label: {
                        Text("\(timeRemaing / 60):\(String(format: "%02d", timeRemaing % 60))")
                            .font(.system(size: 20, weight: .bold))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause" : "play.fill" )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 1)
                }
            }

        }
        .frame(width: 200, height: 120)
        .padding()
        .onReceive(timer) { _ in
            if isRunning && timeRemaing > 0 {
                timeRemaing -= 1
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
