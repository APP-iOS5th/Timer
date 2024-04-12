import SwiftUI
import AVFoundation


class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Beep", withExtension: "mov") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("error. \(error.localizedDescription)")
        }
    }
}

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
    @State private var isRunning = false
    @State private var timeRemaining = 1000
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let randomColors: [Color] = [.red, .blue, .pink, .orange, .black]
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60))
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: randomColors.shuffled()), center: .center
                        ), lineWidth: 10)
                    .rotationEffect((Angle(degrees: -90)))
                    .animation(.easeInOut(duration: 1.0), value: timeRemaining)
                
                VStack {
                    Text("Timer")
                        .font(.title2)
                    
                    Button {
                        switch timeRemaining {
                        case 0..<180:
                            timeRemaining = 180
                        case 180..<300:
                            timeRemaining = 300
                        case 300..<420:
                            timeRemaining = 420
                        case 300..<600:
                            timeRemaining = 600
                        case 600..<900:
                            timeRemaining = 900
                        case 900..<1200:
                            timeRemaining = 1200
                        case 1200..<1500:
                            timeRemaining = 1500
                        case 1500..<1800:
                            timeRemaining = 1800
                        default:
                            timeRemaining = 0
                        }
                    } label: {
                        Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                            .font(.system(size: 40, weight: .bold))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    HStack {
                        Stepper(value: $timeRemaining, in: 0...1800, step: 60) {
                            Text("Setting Time: \(timeRemaining / 60) min")
                        }
                        .padding()
                    }
                    
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause" : "circle")
                            .foregroundStyle(.red)
                    }
                    .padding(.top)
                }
            }
        }
        .frame(width: 400, height: 400)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 10 {
                    SoundManager.instance.playSound()
                }
            } else if isRunning {
                isRunning = false
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
