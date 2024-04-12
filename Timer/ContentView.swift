//
//  ContentView.swift
//  Timer
//
//  Created by JIHYE SEOK on 4/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isPlay = false
    @State private var timeRemaining = 100
    let totalTime = 100
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Image(systemName: "battery.0percent")
                    .resizable()
                    .frame(width: 120, height: 60)
                
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.green)
                    .frame(width: (88.5 * CGFloat(timeRemaining) / CGFloat(totalTime)), height: 40)
                    .offset(x: 9.0, y: -1.5)
                
                Text("\(String(format: "%02d", timeRemaining / 60)):\(String(format: "%02d", timeRemaining % 60))")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .offset(x: -7)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .padding(10)
            
            Button {
                isPlay.toggle()
            } label: {
                Image(systemName: isPlay ? "pause" : "play.fill")
            }
            .buttonStyle(PlainButtonStyle())
            .font(.system(size: 30))
            
        }
        .padding()
        .frame(width: 150, height: 150)
        .onReceive(timer) { _ in
            if isPlay && timeRemaining > 0 {
                timeRemaining -= 1
            } else if isPlay {
                isPlay = false
            }
        }
    }
}

#Preview {
    ContentView()
}
