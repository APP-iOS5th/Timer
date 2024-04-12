//
//  TimerListViewModel.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import Foundation

@Observable
final class TimerListViewModel {
    // MARK: States
    private(set) var timerInfo: [TimerInfo] = [
        .init(time: 30),
        .init(time: 180),
        .init(time: 10),
        .init(time: 50),
        .init(time: 120),
    ]
    
    // MARK: Actions and Reduces
    // TODO: Add methods for appending, removing timer information.
//    func append(with timerInfo: TimerInfo) {}
    
}
