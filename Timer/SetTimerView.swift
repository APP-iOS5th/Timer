//
//  SetTimerView.swift
//  Timer
//
//  Created by 이융의 on 4/12/24.
//

import SwiftUI

struct SetTimerView: View {
    @Binding var timeRemaining: Int

    @State private var hoursText: String = "00"
    @State private var minutesText: String = "00"
    @State private var secondsText: String = "00"
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            VStack(alignment: .center) {
                HStack {
                    TextField("", text: $hoursText)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 50)
                        .onReceive(hoursText.publisher.collect()) {
                            self.hoursText = String($0.prefix(2))
                            limitTextField(&self.hoursText, max: 23)
                        }
                    Text("시")
                    TextField("", text: $minutesText)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 50)
                        .onReceive(minutesText.publisher.collect()) {
                            self.minutesText = String($0.prefix(2))
                            limitTextField(&self.minutesText, max: 59)
                        }
                    Text("분")
                    TextField("", text: $secondsText)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 50)
                        .onReceive(secondsText.publisher.collect()) {
                            self.secondsText = String($0.prefix(2))
                            limitTextField(&self.secondsText, max: 59)
                        }
                    Text("초")
                }
                .padding(.bottom)
                
                Button("타이머 설정") {
                    updateTimer()
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
        }
        .padding()
    }
    
    private func updateTimer() {
        let hours = Int(hoursText) ?? 0
        let minutes = Int(minutesText) ?? 0
        let seconds = Int(secondsText) ?? 0
        
        if hours >= 0, minutes >= 0 && minutes < 60, seconds >= 0 && seconds < 60 {
            timeRemaining = (hours * 3600) + (minutes * 60) + seconds
        } else {
            timeRemaining = 0
            print("유효하지 않은 입력입니다.")
        }
        presentationMode.wrappedValue.dismiss()
    }
    private func limitTextField(_ text: inout String, max: Int) {
        if let value = Int(text), value > max {
            text = "\(max)"
        } else if Int(text) == nil {
            text = ""
        }
    }
}
