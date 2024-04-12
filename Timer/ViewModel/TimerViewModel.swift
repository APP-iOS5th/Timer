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
    @ObservationIgnored
    private lazy var timer: AnyPublisher<Date, Never> = {
        if self.initialTime > 120 {
            return Timer.publish(every: 1, on: .main, in: .default).autoconnect().eraseToAnyPublisher()
        } else {
            return Timer.publish(every: 0.1, on: .main, in: .default).autoconnect().eraseToAnyPublisher()
        }
    }()
    private var cancellable: AnyCancellable?
    
    // MARK: States
    private(set) var initialTime: Double
    private(set) var remainingTime: Double
    private(set) var timerState: TimerState
    
    init(initialTime: Double, remainingTime: Double, timerState: TimerState = .stop) {
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
            remainingTime -= 0.1
        } else if timerState == .run {
            timerState = .stop
        }
    }
}
