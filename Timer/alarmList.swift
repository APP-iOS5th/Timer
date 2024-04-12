//
//  alarmList.swift
//  Timer
//
//  Created by 조성빈 on 4/12/24.
//

import SwiftUI

struct alarmList:View {
    
    @Binding var alarmAry: [alarmModel]
    
    var min: Int
    var sec: Int
    
    var index: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("\(String(format: "%02d", min)) : \(String(format: "%02d", sec))")
                    .font(.system(size: 20))
                Spacer()
                Button(action: {
                    alarmAry.remove(at: index)
                }) {
                    Image(systemName: "xmark.circle")
                }
                .font(.system(size: 20))
                .buttonStyle(PlainButtonStyle())
            }
            .frame(width: 200)
            Rectangle()
                .frame(width: 200, height: 1)
                .opacity(0.2)
        }
    }
}
