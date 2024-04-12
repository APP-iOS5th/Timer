//
//  TimerView.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI
import Combine

enum TimerState {
    case pause
    case run
    case stop
}

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
                Button {
                    switch initialTime {
                        case 0..<180:
                            initialTime = 180
                        case 180..<300:
                            initialTime = 350
                        case 300..<420:
                            initialTime = 420
                        case 300..<600:
                            initialTime = 600
                        case 600..<900:
                            initialTime = 900
                        case 900..<1200:
                            initialTime = 1200
                        case 1200..<1500:
                            initialTime = 1500
                        case 1500..<1800:
                            initialTime = 1800
                        default:
                            initialTime = 0
                    }
                    remainingTime = initialTime
                } label: {
                    Text("\(String(format: "%02d", remainingTime / 60)):\(String(format: "%02d", remainingTime % 60))")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.gray)
                }
                .buttonStyle(.plain)
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
