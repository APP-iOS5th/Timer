//
//  ContentView.swift
//  Timer
//
//  Created by Jungman Bae on 4/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                VStack {
                    Text("00:00")
                        .font(.system(size: 20, weight: .bold))
                    Button {
                        
                    } label: {
                        Image(systemName: "play.fill")
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
