import SwiftUI
import AVFoundation

//struct AlwaysOnTopView: NSViewRepresentable {
//    func updateNSView(_ nsView: NSView, context: Context) {
//        if isAlwaysOnTop {
//            window.level = .floating
//        } else {
//            window.level = .normal
//        }
//    }
//    
//    let window: NSWindow
//    let isAlwaysOnTop: Bool
//    
//    func makeNSView(context: Context) -> NSView {
//        let view = NSView()
//        return view
//    }
//}
//
//class SoundManager {
//    static let instance = SoundManager()
//    var player: AVAudioPlayer?
//    
//    func playSound() {
//        guard let url = Bundle.main.url(forResource: "Beep", withExtension: "mov") else { return }
//        
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.play()
//        } catch let error {
//            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
//        }
//    }
//}

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            ZStack {
                ProgressCircle()
                VStack {
                    
//                    Button {
//                        switch timeRemaining {
//                        case 0..<180:
//                            timeRemaining = 180
//                        case 180..<300:
//                            timeRemaining = 300
//                        case 300..<420:
//                            timeRemaining = 420
//                        case 300..<600:
//                            timeRemaining = 600
//                        case 600..<900:
//                            timeRemaining = 900
//                        case 900..<1200:
//                            timeRemaining = 1200
//                        case 1200..<1500:
//                            timeRemaining = 1500
//                        case 1500..<1800:
//                            timeRemaining = 1800
//                        default:
//                            timeRemaining = 0
//                        }
//                        
//                    } label: {
//                        Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
//                            .font(.system(size: 20, weight: .bold))
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    Button {
//                        isRunning.toggle()
//                    } label: {
//                        Image(systemName: isRunning ? "pause" : "play.fill")
//                    }
                }
            }
            
        }
        .frame(width: 100, height: 100)
        .padding()
//        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
//        .onReceive(timer) { _ in
//            if isRunning && timeRemaining > 0 {
//                timeRemaining -= 1
//                if timeRemaining <= 10 {
//                    NSSound.beep()
//                }
//            } else if isRunning {
//                isRunning = false
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
