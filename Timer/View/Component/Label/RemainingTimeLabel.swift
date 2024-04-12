//
//  RemainingTimeLabel.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI

struct RemainingTimeLabel: View {
    private let remainingTime: Int
    
    init(remainingTime: Double) {
        self.remainingTime = Int(remainingTime)
    }
    
    var body: some View {
        Text("\(String(format: "%02d", remainingTime / 60)):\(String(format: "%02d", remainingTime % 60))")
            .font(.system(size: 60, weight: .bold))
            .foregroundStyle(.gray)
    }
}

#Preview {
    RemainingTimeLabel(remainingTime: 110)
}
