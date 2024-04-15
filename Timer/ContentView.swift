import SwiftUI
import AVFoundation

// 모래시계 아이콘 상태
enum HourglassState {
    case bottomHalfFilled
    case normal
    case topHalfFilled
}

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
    @State private var timeRemaining: Int = 0
    @State private var minuteInput: String = ""
    @State private var secondInput: String = ""
    @State private var hourglassState: HourglassState = .bottomHalfFilled
    
    // 제공되는 타이머
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // 1초마다, 메인 스레드, 일반 모드, 자동 연결
    
    var body: some View {
        ZStack {
            VStack{
                Button {
                    // 클릭(시작) 후 초기값 셋팅
                    isRunning = !isRunning // 일시정지 가능
                    
                    if !isRunning || (minuteInput.isEmpty || secondInput.isEmpty) {
                        return
                    }
                        
                    hourglassState = .normal
                    
                    var temp: Int = 0

                    if let minute = Int(minuteInput) {
                        temp += minute * 60
                    }
                    
                    if let second = Int(secondInput) {
                        temp += second
                    }
                    
                    // 더한 분, 초값이 0이면 종료
                    if (temp == 0) {
                        return
                    } else {
                        timeRemaining = temp
                    }

                } label: {
                    switch hourglassState {
                        case .bottomHalfFilled:
                            Image(systemName: "hourglass.bottomhalf.filled")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                        case .normal:
                            Image(systemName: "hourglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                        case .topHalfFilled:
                            Image(systemName: "hourglass.tophalf.filled")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                    }
                }.buttonStyle(PlainButtonStyle())
                HStack(spacing: 1) {
                    TextField("분", text: $minuteInput)
                        .frame(width: 45,height: 45)
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.center)
                        .onChange(of:minuteInput) { oldValue, newValue in
                            if let number = Int(newValue) {
                                let isOverNum = Int(newValue)! / 10
                                if isOverNum >= 10 {
                                    minuteInput = oldValue
                                    return
                                }
                                minuteInput = String(format: "%02d", min(max(number, 0), 59))
                            }
                        }
                    Text(":")
                        .font(.system(size: 15, weight: .bold))
                        .frame(width: 20)
                    TextField("초", text: $secondInput)
                        .frame(width: 45, height: 45)
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.center)
                        .onChange(of: secondInput) { oldValue, newValue in
                            if let number = Int(newValue) {
                                let isOverNum = Int(newValue)! / 10
                                if isOverNum >= 10 {
                                    secondInput = oldValue
                                    return
                                }
                                secondInput = String(format: "%02d", min(max(number, 0), 60))
                                if minuteInput.isEmpty {
                                    minuteInput = "00"
                                }
                            }
                        }
                }
            }

        }
        .frame(width: 120, height: 120)
        .padding()
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: true)) // true or false
        .onReceive(timer) { _ in
            // 실행중
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                // 흐르는 시간 시각화
                let min = timeRemaining / 60
                let sec = timeRemaining % 60
                minuteInput = String(min)
                secondInput = String(sec)
                
                // 10초 남았을 때 경고 소리
                if timeRemaining <= 10 {
                    NSSound.beep()
                }

            // 일시정지
            } else if !isRunning && timeRemaining > 0 {
                hourglassState = .normal
                
            // 실행종료
            } else {
                isRunning = false
                hourglassState = .topHalfFilled
                // 애니메이션
//                    .bottomHalfFilled
            }
        }
    }
}


#Preview {
    ContentView()
}
