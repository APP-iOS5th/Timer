import SwiftUI
import AVFoundation

// 창 항상 맨위로 표시
struct AlwaysOnTopView: NSViewRepresentable {
    let window: NSWindow
    let isAlwaysOnTop: Bool
    
    func makeNSView(context: Context) -> some NSView {
        let view = NSView()
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        if isAlwaysOnTop {
            window.level = .floating
        } else {
            window.level = .normal
        }
    }
}

// 경고 소리
class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Beep", withExtension: "mov") else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    @State private var isRunning = false // 실행 중인지
    @State private var timeRemaining = 0
    
    // 제공되는 타이머
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // 1초마다, 메인 스레드, 일반 모드, 자동 연결
    
    var body: some View {
        ZStack { // 원 안에 시간과 버튼이 겹치게 하기 위해
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 10)
            Circle()
                .trim(from: 0, to: CGFloat(timeRemaining) / (30 * 60)) // 시간 설정과 맞춰줌
                .stroke(Color.red, lineWidth: 10)
                .rotationEffect(.degrees(-90)) // 시작 위치 변경

            VStack {
                // 시간 설정
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
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))") // 정수를 문자열로 변환할 때 최소 2자리, 필요한 경우 앞에 0을 채움
                        .font(.system(size: 20, weight: .bold))
                }
                Button {
                    isRunning.toggle()
                } label: {
                    Image(systemName: isRunning ? "pause" : "play.fill")
                }
            }
        }
        .frame(width: 100, height: 100)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true)) // true or false
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1 // 1초씩 감소
                if timeRemaining <= 10 { // 10초 남았을 때 경고 소리
                    NSSound.beep()
                }
            } else if isRunning {
                isRunning = false // 타이머 끝나면 버튼 모양 바꾸기
            }
        }
    }
}

#Preview {
    ContentView()
}
