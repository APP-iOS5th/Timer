//
//  TimerView.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import SwiftUI

struct TimerView: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    style: .init(
                        lineWidth: 8,
                        dash: [1, 3]
                    )
                )
                .rotation(.degrees(-90))
                .foregroundStyle(.accent)
                .padding()
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.gray)
                        .font(.system(size: 28))
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Button {
                
                } label: {
                    Image(systemName: "play.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, .accent)
                        .font(.system(size: 28))
                }
                .buttonStyle(.plain)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(width: 200, height: 200)
        .background(Color.black)
    }
}

#Preview {
    TimerView()
}
