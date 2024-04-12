//
//  ContentView.swift
//  Timer
//
//  Created by Jungman Bae on 4/12/24.
//

import SwiftUI
import AVFoundation

class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "bamSong", withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
}

final class TimerView: ObservableObject {
    
    enum TimerState {
          case active
          case paused
          case resumed
          case cancelled
      }
    
    private var timer = Timer()
    private var totalTimeForCurrentSelection: Int {
            selectedMinutesAmount * 60
        }
    
    @Published var selectedMinutesAmount = 5
    @Published var state: TimerState = .cancelled {
        didSet {
              switch state {
              case .cancelled:
                  timer.invalidate()
                  secondsToCompletion = 0
                  progress = 0

              case .active:
                  startTimer()

                  secondsToCompletion = totalTimeForCurrentSelection
                  progress = 1.0

                  updateCompletionDate()

              case .paused:
                  timer.invalidate()

              case .resumed:
                  startTimer()
                  updateCompletionDate()
              }
          }
    }
    
    @Published var progress: Float = 0.0
    @Published var secondsToCompletion = 0
    @Published var completionDate = Date.now
    
    let minutesRange = 1...10
    
    private func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
                guard let self else { return }

                self.secondsToCompletion -= 1
                self.progress = Float(self.secondsToCompletion) / Float(self.totalTimeForCurrentSelection)

                if self.secondsToCompletion < 0 {
                    self.state = .cancelled
                    SoundManager.instance.playSound()
                }
            })
        }
    
    private func updateCompletionDate() {
           completionDate = Date.now.addingTimeInterval(Double(secondsToCompletion))
       }
}



struct ContentView: View {

    @StateObject private var model = TimerView()
    
    var timePickerControl: some View {
        HStack() {

            TimePickerView(title: "min", range: model.minutesRange, binding: $model.selectedMinutesAmount)
        }
        .frame(width: 360, height: 255)
        .padding(.all, 32)
    }
    
    var progressView: some View {
        ZStack {
            withAnimation {
                CircularProgressView(progress: $model.progress)
            }

            VStack {
                Text(model.secondsToCompletion.asTimestamp)
                    .font(.largeTitle)
                HStack {
                    Image(systemName: "bell.fill")
                    Text(model.completionDate, format: .dateTime.hour().minute())
                }
            }
        }
        .frame(width: 360, height: 255)
        .padding(.all, 32)
    }
    
    var timerControls: some View {
        HStack {
            Button("Cancel") {
                model.state = .cancelled
            }
            .buttonStyle(CancelButtonStyle())

            Spacer()

            switch model.state {
            case .cancelled:
                Button("Start") {
                    model.state = .active
                }
                .buttonStyle(StartButtonStyle())
            case .paused:
                Button("Resume") {
                    model.state = .resumed
                }
                .buttonStyle(PauseButtonStyle())
            case .active, .resumed:
                Button("Pause") {
                    model.state = .paused
                }
                .buttonStyle(PauseButtonStyle())
            }
        }
        .padding(.horizontal, 32)
    }

    var body: some View {
        VStack {
            if model.state == .cancelled {
                timePickerControl
            } else {
                progressView
            }
            timerControls
            Spacer()
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        .background(.black)
        .foregroundColor(.white)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
