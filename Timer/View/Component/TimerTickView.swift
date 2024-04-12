//
//  TimerTickView.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI

struct TimerTickView: View {
    private let totalTime: Double
    private let remainingTime: Double
    private var progress: Double {
        remainingTime / totalTime
    }
    
    init(totalTime: Double, remainingTime: Double) {
        self.totalTime = totalTime
        self.remainingTime = remainingTime
    }
    
    init() {
        self.totalTime = 0
        self.remainingTime = 0
    }
    
    var body: some View {
        Circle()
            .trim(
                from: 0,
                to: progress
            )
            .stroke(
                style: .init(
                    lineWidth: 15,
                    dash: [1, 3]
                )
            )
            .rotation(.degrees(-90))
            .foregroundStyle(.accent)
            .padding()
            .animation(.linear(duration: 0.1), value: progress)
    }
}

#Preview {
    TimerTickView()
}
