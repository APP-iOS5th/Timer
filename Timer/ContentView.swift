import SwiftUI
import AVFoundation

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
    @State private var userInput = "" // 입력
    @State private var timeRemaining = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat((Int(userInput) ?? 0) * 60))
                    .stroke(Color.purple, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                
                
                VStack {
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                        .font(.system(size: 25, weight: .bold))
                    
                        Button {
                            timeRemaining = 0
                            isRunning = false
                            userInput = ""
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .buttonStyle(PlainButtonStyle())
                        .font(.system(size: 8))
                        .offset(CGSize(width: 40, height: -15))
                    
                    TextField("분을 입력", text: $userInput) // 입력
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.trailing, .leading])
                    
                    Button {
                        if isRunning {
                            isRunning.toggle()
                        } else {
                            if let inputTime = Int(userInput) {
                                timeRemaining = inputTime * 60
                                isRunning.toggle()
                            }
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
