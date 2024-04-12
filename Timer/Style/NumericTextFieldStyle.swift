//
//  NumericTextFieldStyle.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI

struct NumericTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .textFieldStyle(.plain)
            .background(
                RoundedRectangle(
                    cornerRadius: 15.0,
                    style: .continuous
                )
                .stroke(Color.orange, lineWidth: 3)
            )
            .padding()
            .multilineTextAlignment(.center)
    }
}
