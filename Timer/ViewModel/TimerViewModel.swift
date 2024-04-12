//
//  TimerViewModel.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import Foundation

@Observable
class TimerViewModel {
    private let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    // MARK: States
    private(set) var initialTime: Int
    private(set) var remainingTime: Int
    private(set) var timerState: TimerState
    
    init(initialTime: Int, remainingTime: Int, timerState: TimerState = .stop) {
        self.initialTime = initialTime
        self.remainingTime = remainingTime
        self.timerState = timerState
    }
    
    // MARK: Actions and Reduces
    func start() {
        self.timerState = .run
    }
    
    func pause() {
        self.timerState = .pause
    }
    
    func stop() {
        self.timerState = .stop
    }
}
