//
//  TimerViewModel.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import Foundation
import Combine

@Observable
final class TimerViewModel {
    private let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    private var cancellable: AnyCancellable?
    
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
        cancellable = timer
            .sink(receiveValue: elapse(_:))
    }
    
    func pause() {
        self.timerState = .pause
    }
    
    func stop() {
        self.timerState = .stop
        self.remainingTime = self.initialTime
        self.cancellable?.cancel()
    }
}

private extension TimerViewModel {
    func elapse(_ date: Date) {
        if self.timerState == .run && self.remainingTime > 0 {
            remainingTime -= 1
        } else if timerState == .run {
            timerState = .stop
        }
    }
}
