//
//  TimerCell.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI

struct TimerCell: View {
    private let totalTime: Int
    private let remainingTime: Int
    
    init(totalTime: Int, remainingTime: Int) {
        self.totalTime = totalTime
        self.remainingTime = remainingTime
    }
    
    init(_ time: Int) {
        self.totalTime = time
        self.remainingTime = time
    }
    
    var body: some View {
        ZStack {
            TimerTickView(totalTime: totalTime, remainingTime: remainingTime)
            Circle()
                .rotation(.degrees(-90))
                .foregroundStyle(Color("DarkGray"))
                .padding(20)
            InitialTimeLabel(time: totalTime)
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
