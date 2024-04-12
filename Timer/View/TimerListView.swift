//
//  TimerListView.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI

struct TimerListView: View {
    @State private var timerInfo: [TimerInfo] = [
        .init(time: 30),
        .init(time: 180),
        .init(time: 10),
        .init(time: 50),
        .init(time: 120),
    ]
    
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
                    ForEach(timerInfo) { timer in
                        NavigationLink {
                            TimerView(timer)
                        } label: {
                            TimerCell(timer.time)
                        }

                    }
                }
            }
            .padding(.top)
        }
        .frame(width: 300, height: 300)
        .buttonStyle(.plain)
        .background(Color.black)
    }
}

#Preview {
    TimerListView()
}
