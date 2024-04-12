//
//  ContentView.swift
//  Timer
//
//  Created by mosi on 4/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isRunning = false
    @State private var timeRemaining = 100
    
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                
                Circle()
                    // trim은 시작위치가 오른쪽 90도
                    .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90)) // -90도 돌려준다
                
                VStack{
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
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
