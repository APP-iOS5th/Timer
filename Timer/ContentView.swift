//
//  ContentView.swift
//  Timer
//
//  Created by 차지용 on 4/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 100 //타이머의 남은 시간을 추적
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining)/(30 * 60)) //특정 부분만 남기고 나머지 부분 절단
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                VStack {
                    Text("\(timeRemaining/60) : \(String(format: "%02d", timeRemaining % 60))")
                        .font(.system(size:20, weight: .regular))
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
