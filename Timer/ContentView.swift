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

class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "notify", withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
}


struct ContentView: View {
    @State private var isRunning = false
    @State private var minutesInput = ""
    @State private var secondsInput = ""
    @State private var timeRemaining = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat((Int(minutesInput) ?? 0) * 60 + (Int(secondsInput) ?? 0)))
                    .stroke(Color.indigo.opacity(50), lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                
                Button {
                    timeRemaining = 0
                    isRunning = false
                    minutesInput = ""
                    secondsInput = ""
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(PlainButtonStyle())
                .font(.system(size: 8))
                .offset(CGSize(width: 47, height: -28))
                
                VStack {
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                        .font(.system(size: 30, weight: .bold))
                    
                    HStack {
                        TextField("M", text: Binding(
                            get: {
                                return self.minutesInput
                            },
                            set: {
                                if let newValue = Int($0), newValue >= 0 && newValue <= 60 {
                                    self.minutesInput = "\($0)"
                                } else {
                                    self.minutesInput = "0"
                                }
                            }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)
                        .frame(width: 50)
                        
                        Text(":")
                        
                        TextField("S", text: Binding(
                            get: {
                                return self.secondsInput
                            },
                            set: {
                                if let newValue = Int($0), newValue >= 0 && newValue <= 60 {
                                    self.secondsInput = "\($0)"
                                } else {
                                    self.secondsInput = "0"
                                }
                            }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.trailing)
                        .frame(width: 50)
                    }
                    
                    Button {
                        if isRunning {
                            isRunning.toggle()
                        } else {
                            let minutes = Int(minutesInput) ?? 0
                            let seconds = Int(secondsInput) ?? 0
                            timeRemaining = minutes * 60 + seconds
                            isRunning.toggle()
                        }
                    } label: {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.system(size: 20))
                    .padding(1)
                }
            }
        }
        .frame(width: 150, height: 150)
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        .padding()
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
            } else if isRunning {
                SoundManager.instance.playSound()
                isRunning = false
            }
        }
    }
}





#Preview {
    ContentView()
}
