//
//  TimerCell.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI

struct TimerCell: View {
    private let totalTime: Double
    private let remainingTime: Double
    
    init(totalTime: Double, remainingTime: Double) {
        self.totalTime = totalTime
        self.remainingTime = remainingTime
    }
    
    init(_ time: Double) {
        self.totalTime = time
        self.remainingTime = time
    }
    
    var body: some View {
        ZStack {
            Circle()
                .rotation(.degrees(-90))
                .foregroundStyle(Color.deepGray)
                .padding(8)
            TimerTickView(totalTime: totalTime, remainingTime: remainingTime)
            InitialTimeLabel(time: totalTime)
                .scaleEffect(1.2)
        }
        .frame(width: 150, height: 150)
        .background(Color.black)
    }
}

#Preview {
    TimerCell(
        totalTime: 30,
        remainingTime: 30
    )
}

#Preview {
    TimerCell(
        totalTime: 60,
        remainingTime: 60
    )
}
