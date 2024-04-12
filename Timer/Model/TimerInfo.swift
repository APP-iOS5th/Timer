//
//  TimerInfo.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import Foundation

struct TimerInfo: Hashable, Identifiable {
    let id: UUID
    let time: Double
    
    init(id: UUID = UUID(), time: Double) {
        self.id = id
        self.time = time
    }
}
