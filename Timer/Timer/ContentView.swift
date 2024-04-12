//
//  ContentView.swift
//  Timer
//
//  Created by uunwon on 4/12/24.
//

import SwiftUI

@available(iOS 15.0, *)
struct ContentView: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.customPink.opacity(0.9), lineWidth: 10)
                VStack {
                    Text("00:00")
                        .font(.system(size: 20, weight: .bold))
                    Button {
                        
                    } label: {
                        Image(systemName: "play.fill")
                            .imageScale(.large)
                    }
                }
            }
        }
        .frame(width: 100, height: 100)
        .padding()
    }
}

#Preview {
    ContentView()
}
