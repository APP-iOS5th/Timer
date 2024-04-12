//
//  TimerView.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI
import Combine

struct TimerView: View {
    @State private var viewModel = TimerViewModel(initialTime: 30, remainingTime: 30)
    
    var body: some View {
        ZStack {
            TimerTickView(totalTime: viewModel.initialTime, remainingTime: viewModel.remainingTime)
            TimerTickView()
                .opacity(0.3)
            VStack {
                RemainingTimeLabel(remainingTime: viewModel.remainingTime)
                InitialTimeLabel(time: viewModel.initialTime)
            }
            
            HStack {
                Button {
                    viewModel.stop()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.gray)
                        .font(.system(size: 28))
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Button {
                    viewModel.timerState == .run
                    ? viewModel.pause()
                    : viewModel.start()
                } label: {
                    Image(
                        systemName: viewModel.timerState == .run
                        ? "pause.circle.fill"
                        : "play.circle.fill"
                    )
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
