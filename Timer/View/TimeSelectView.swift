//
//  TimeSelectView.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI
import Combine

struct TimeSelectView: View {
    @State private var minute = 0
    @State private var second = 0
    
    @Environment(\.dismiss) var dismiss
    
    private let viewModel: TimerListViewModel
    
    init(viewModel: TimerListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(spacing: 0) {
                    NumericTextField(number: $minute)
                    Text("minutes")
                }
                VStack(spacing: 0) {
                    NumericTextField(number: $second)
                    Text("seconds")
                }
            }
            Button {
                viewModel.append(with: TimerInfo(time: Double(minute * 60 + second)))
                dismiss()
            } label: {
                Text("Add")
            }
            .buttonStyle(AddButtonStyle())
        }
        .frame(width: 300, height: 200)
    }
}

#Preview {
    TimeSelectView(
        viewModel: TimerListViewModel()
    )
}
