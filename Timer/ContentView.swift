//
//  ContentView.swift
//  Timer
//
//  Created by 차지용 on 4/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 1 //타이머의 남은 시간을 추적
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining)/(5 * 60)) //특정 부분만 남기고 나머지 부분 절단
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
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
        //타이머 동작하는 클로저
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
            }
            else if isRunning {
                isRunning = false
            }
        }
    }
}

#Preview {
    ContentView()
}
