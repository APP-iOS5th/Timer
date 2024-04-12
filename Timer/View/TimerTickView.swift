//
//  TimerTickView.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI

struct TimerTickView: View {
    private let totalTime: Int
    private let remainingTime: Int
    
    init(totalTime: Int, remainingTime: Int) {
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
                to: CGFloat(remainingTime) / CGFloat(totalTime)
            )
            .stroke(
                style: .init(
                    lineWidth: 8,
                    dash: [1, 3]
                )
            )
            .rotation(.degrees(-90))
            .foregroundStyle(.accent)
            .padding()
    }
}

#Preview {
    TimerTickView()
}
