//
//  TimerInfo.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import Foundation

struct TimerInfo: Hashable, Identifiable {
    let id: UUID
    let time: Int
    
    init(id: UUID = UUID(), time: Int) {
        self.id = id
        self.time = time
    }
}
