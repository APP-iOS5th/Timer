//
//  alarmModel.swift
//  Timer
//
//  Created by 조성빈 on 4/12/24.
//

import Foundation

struct alarmModel: Identifiable, Equatable {
    var id: UUID
    var min: Int
    var sec: Int
}
