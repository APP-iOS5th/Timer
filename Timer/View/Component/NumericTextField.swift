//
//  NumericTextField.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI
import Combine

struct NumericTextField: View {
    @State private var text: String = ""
    @Binding var number: Int
    
    var body: some View {
        TextField("", text: $text)
            .font(.system(size: 36))
            .textFieldStyle(NumericTextFieldStyle())
            .onReceive(Just(text)) { value in
                let filtered = value.filter(CharacterSet.decimalDigits.contains(_:))
                if filtered != value {
                    self.text = filtered
                }
                if let number = Int(filtered) {
                    self.number = number
                } else {
                    self.number = 0
                }
            }
    }
}

#Preview {
    NumericTextField(
        number: .constant(0)
    )
}
