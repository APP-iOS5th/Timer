//
//  AddTimerButton.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI

struct AddTimerButton: View {
    var body: some View {
        ZStack {
            Circle()
                .rotation(.degrees(-90))
                .foregroundStyle(.orange)
                .padding(8)
            TimerTickView()
                .colorMultiply(.red)
            Image(systemName: "plus")
                .font(.system(size: 48))
        }
        .frame(width: 150, height: 150)
        .background(Color.black)
    }
}

#Preview {
    AddTimerButton()
}
