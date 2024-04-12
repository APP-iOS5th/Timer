//
//  TimerListView.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI

struct TimerListView: View {
    @State private var viewModel = TimerListViewModel()
    @State private var isPresented = false
    
    private var columns: [GridItem] = [
        .init(.flexible()),
        .init(.flexible()),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Timer List")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                LazyVGrid(columns: columns) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        AddTimerButton()
                    }
                    ForEach(viewModel.timerInfo) { timer in
                        NavigationLink {
                            TimerView(timer)
                        } label: {
                            TimerCell(timer.time)
                        }
                    }
                }
            }
            .padding(.top)
            .sheet(isPresented: $isPresented) {
                TimeSelectView(viewModel: viewModel)
            }
        }
        .frame(width: 300, height: 300)
        .buttonStyle(.plain)
        .background(Color.black)
    }
}

#Preview {
    TimerListView()
}
