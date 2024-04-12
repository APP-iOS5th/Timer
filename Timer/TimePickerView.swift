import SwiftUI

struct TimePickerView: View {
    // This is used to tighten up the spacing between the Picker and its
    // respective label
    //
    // This allows us to avoid having to use custom
    private let pickerViewTitlePadding: CGFloat = 4.0

    let title: String
    let range: ClosedRange<Int>
    let binding: Binding<Int>

    var body: some View {
        HStack(spacing: 4.0) {
            Picker(title, selection: binding) {
                ForEach(range, id: \.self) { timeIncrement in
                    HStack {
                        Text("\(timeIncrement)")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .pickerStyle(DefaultPickerStyle())
            .labelsHidden()

            Text(title)
                .fontWeight(.bold)
        }
    }
}
