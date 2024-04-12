//
//  TimerView.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI
import Combine

struct TimerView: View {
    private let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    @State private var initialTime = 0
    @State private var remainingTime = 0
    @State private var timerState: TimerState = .stop
    
    var body: some View {
        ZStack {
            TimerTickView(totalTime: initialTime, remainingTime: remainingTime)
            TimerTickView()
                .opacity(0.3)
            VStack {
                RemainingTimeLabel(remainingTime: remainingTime)
                InitialTimeLabel(time: initialTime)
            }
            
            HStack {
                Button {
                    timerState = .stop
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.gray)
                        .font(.system(size: 28))
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Button {
                    timerState = .run
                } label: {
                    Image(systemName: "play.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, .accent)
                        .font(.system(size: 28))
                }
                .buttonStyle(.plain)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(width: 200, height: 200)
        .background(Color.black)
        .onReceive(timer) { _ in
            if timerState == .run && remainingTime > 0 {
                remainingTime -= 1
            } else if timerState == .run {
                timerState = .stop
            }
        }
    }
}

#Preview {
    TimerView()
}

extension CharacterSet {
    func contains(_ character: Character) -> Bool {
        character.unicodeScalars.allSatisfy(contains(_:))
    }
}
