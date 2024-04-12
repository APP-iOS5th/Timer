//
//  InitialTimeLabel.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI

struct InitialTimeLabel: View {
    private let time: Int
    
    init(time: Double) {
        self.time = Int(time)
    }
    
    var body: some View {
        if time % 60 == 0 {
            Text("\(String(format: "%02d", time / 60)) min")
                .font(.title)
                .foregroundStyle(.gray)
        } else {
            Text("\(String(format: "%02d", time / 60)):\(String(format: "%02d", time % 60))")
                .font(.title)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    InitialTimeLabel(time: 50)
}

#Preview {
    InitialTimeLabel(time: 60)
}
