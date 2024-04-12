//
//  AddButtonStyle.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI

struct AddButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.init(top: 10, leading: 25, bottom: 10, trailing: 25))
            .background(
                Capsule().fill(.green)
            )
            .foregroundStyle(.white)
    }
}
