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
    @State private var timeRemaining = 10
    @State private var isOnTop = true
    @State private var startTime = 10
    @State var widthValue: CGFloat = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .top){
                Button(){
                    isOnTop.toggle()
                } label: {
                    Image(systemName: isOnTop ? "pin" : "pin.slash")
                }.buttonStyle(PlainButtonStyle())
                Button(){
                    isRunning.toggle()
                    withAnimation(.easeInOut(duration: TimeInterval(startTime))) {
                    }
                } label: {
                    Image(systemName: isRunning ? "pause" : "play.fill")
                }.buttonStyle(PlainButtonStyle())
                Button(){
                    isRunning.toggle()
                    timeRemaining = startTime
                    widthValue = 0
                } label: {
                    if isRunning {
                        Image(systemName: "return")
                    }
                             }.buttonStyle(PlainButtonStyle())
                Spacer()
                
            }
            Spacer()
            ZStack {
                HStack(){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(widthValue <= 30 ? Color.red : widthValue <= 50 ? Color.yellow :Color.green)
//                        .frame(width: 80, height: 50)
                        .frame(height: 50)
                        .animation(.easeInOut(duration: 1.5), value: widthValue)
                        .frame(width: widthValue)
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .offset(CGSize(width: 4, height: -1))
                    
                }
                
                
                Image(systemName: "battery.0percent")
                    .resizable()
                    .frame(width: 100, height: 60)
                    .foregroundColor(.white)
                
                VStack {
                        
                    
                    Button {
                            switch timeRemaining {
                            case 0..<180:
                                timeRemaining = 180
                                startTime = 180
                            case 180..<300:
                                timeRemaining = 300
                                startTime = 300
                            case 300..<420:
                                timeRemaining = 420
                                startTime = 420
                            case 300..<600:
                                timeRemaining = 600
                                startTime = 600
                            case 600..<900:
                                timeRemaining = 900
                                startTime = 900
                            case 900..<1200:
                                timeRemaining = 1200
                                startTime = 1200
                            case 1200..<1500:
                                timeRemaining = 1500
                                startTime = 1500
                            case 1500..<1800:
                                timeRemaining = 1800
                                startTime = 1800
                            default:
                                timeRemaining = 0
                            }
                        
                    
                    } label: {
                        Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(widthValue <= 67 ? Color.white : Color.black)
                            .offset(CGSize(width: -5, height: -1))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            
        }
        .frame(width: 100, height: 100)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: isOnTop))
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if widthValue <= 80{
                    widthValue += 80 / CGFloat(startTime)
                                }
                if timeRemaining <= 10 {
                    NSSound.beep()
                }
            } else if isRunning {
                isRunning = false
                widthValue = 0
                timeRemaining = startTime
                
                
            }
        }
    }
}

#Preview {
    ContentView()
}
