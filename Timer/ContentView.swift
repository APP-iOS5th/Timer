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
        guard let url = Bundle.main.url(forResource: "Output", withExtension: "mov") else { return }
        
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
    
    //시간 추가 값
    private let timeList: [Int] = [30, 10, 5, 1]
    
    // 거북이 위칫값
    @State private var torToisePosition: CGFloat = 0
    // 최대 위치 값
    private let maxTorToisePosition: CGFloat = 270
    
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack (spacing:20) {
            GeometryReader { geometry in
                HStack {
                    Image(systemName: "tortoise.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .position(x: torToisePosition , y:0)
                }
            }
            .frame(width: 250, height: 20)
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / (60 * 60))
                    .stroke(Color.red, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                        .font(.system(size: 20, weight: .bold))
                        .kerning(3)
                    
                    
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: isRunning ? "pause" : "play.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding([.top,.bottom], 16)
                    
                    
                    Button {
                        timeRemaining = 0
                        torToisePosition = 0
                    } label: {
                        Text("초기화")
                    }
                }
                
            }
            
            HStack {
                ForEach(timeList, id: \.self) { seletedTime in
                    Button {
                        isRunning = false
                        timeRemaining += (60 * seletedTime)
                    } label: {
                        Text("+\(seletedTime)분")
                    }
                }
            }
            
            
        }
        .frame(width: 250, height: 250)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true))
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 10 {
                    NSSound.beep()
                }
                // 거북이 위치 업데이트
                torToisePosition += 10
                
                // 거북이 위치 다시 초기화
                if torToisePosition >= maxTorToisePosition {
                    torToisePosition = -20
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
