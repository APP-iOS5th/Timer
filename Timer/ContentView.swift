

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
        guard let url = Bundle.main.url(forResource: "Beep", withExtension: "mov") else { return }
        
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
    @State private var timeRemaining = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                
            }
            ZStack {
                Circle()
                    //.stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    .fill(LinearGradient(colors: [.gradation1, .gradation2], startPoint: .top, endPoint: .bottom))
                    .shadow(color: .black.opacity(0.2), radius: 10)
                
                Circle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 2)
                    .fill(RadialGradient(colors: [.gradation2, .gradation1], center: .center, startRadius: 100, endRadius: 130))
                    .frame(width: 140, height: 140)
                    .shadow(color: .neonGreen.opacity(0.2), radius: 4)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (10 * 60))
                    //.stroke(Color.blue, lineWidth: 10)
                    .stroke(LinearGradient(colors: [.neonGreen, .neonGreen2], startPoint: .top, endPoint: .bottom), lineWidth: 2)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 140, height: 140)
                    .shadow(color: .neonGreen.opacity(0.8), radius: 10)
                    .animation(.easeInOut)
                
                Image("lion")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .offset(y: -36)
                
                VStack {
                    Button {
                        switch timeRemaining {
                        case 0..<60:
                            timeRemaining = 60
                        case 60..<120:
                            timeRemaining = 120
                        case 120..<180:
                            timeRemaining = 180
                        case 180..<240:
                            timeRemaining = 240
                        case 240..<300:
                            timeRemaining = 300
                        case 300..<360:
                            timeRemaining = 360
                        case 360..<420:
                            timeRemaining = 420
                        case 420..<480:
                            timeRemaining = 480
                        case 480..<540:
                            timeRemaining = 540
                        case 540..<600:
                            timeRemaining = 600
                        default:
                            timeRemaining = 0
                        }

                    } label: {
                        Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                            .font(.system(size: 35, weight: .light))

                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(3)
                    .offset(y: 9)
                    Button {
                        isRunning.toggle()
                    } label: {
                        Text(isRunning ? "Stop" : "Start")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(isRunning ? 0.5 : 1)
                    .offset(y: 5)
                }
            }
                
        }
        .frame(width: 150, height: 150)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
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
}


#Preview {
    ContentView()
}
