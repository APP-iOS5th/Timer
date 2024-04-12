import SwiftUI
import AVFoundation

struct AlwaysOnTopView: NSViewRepresentable {
  let window: NSWindow
  let isAlwaysOnTop: Bool

  func makeNSView(context: Context) -> NSView {
    let view = NSView()
    return view
  }

  func updateNSView(_ nsView: NSView, context: Context) {
    if isAlwaysOnTop {
      window.level = .floating
    } else {
      window.level = .normal
    }
  }
}

struct ContentView: View {
  @State private var isRunning = false // 버튼 토글
  @State private var timeRemaining = 0 // time

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  let timeOptions = [60, 90, 120, 150, 180, 210, 240, 270, 300, 420, 600, 900, 1200, 1500, 1800]

  var body: some View {
    VStack {
      Picker("Select Time", selection: $timeRemaining) {
        ForEach(timeOptions, id: \.self) { time in
          Text("\(time / 60):\(String(format: "%02d", time % 60))")
            .tag(String(time))
        }
      }
      .pickerStyle(MenuPickerStyle())
      .frame(width: 120)
      .padding()

      ZStack {
        Circle().stroke(Color.gray.opacity(0.2), lineWidth: 10)
        Circle()
          .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
          .stroke(Color.red.opacity(0.5), lineWidth: 10)
          .rotationEffect(.degrees(-90))
        VStack {
          Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
            .font(.system(size: 20, weight: .bold))
          Button {
            isRunning.toggle()
          } label: {
            Image(systemName: isRunning ? "pause.fill" : "play.fill")
          }
        }
      }
      .frame(width: 100, height: 100)
      .padding()
      .onReceive(timer) { _ in
        if isRunning && timeRemaining > 0 {
          timeRemaining -= 1
          if timeRemaining <= 10 {
            NSSound.beep()
          }
        } else if isRunning {
          isRunning = false
        }
      }
    }
      .frame(width: 150, height: 200)
      .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))

  }
}

#Preview {
  ContentView()
}
