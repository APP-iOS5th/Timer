//
//  ContentView.swift
//  MacTimer
//
//  Created by Chung Wussup on 4/11/24.
//

import SwiftUI
import AVKit

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
    @State var defaultSeconds: Int = 0
    @State var seconds: Int = 0
    @State var isPlay: Bool = false
    @State var audioPlayer: AVAudioPlayer!
    
    private let time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        VStack {
            Spacer()
                .frame(height: 30)
          
            circleView()
            
            Spacer()
                .frame(height: 30)
            
            minButtonView()
            Spacer()
            
        }
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: isPlay ? true : false))
        .onReceive(time) { _ in
            if seconds > 0 && isPlay {
                seconds -= 1
                
                if seconds == 0 && isPlay{
                    playSound("sampleSound")
                    isPlay = false
                    defaultSeconds = 0
                }
                
            } else {
                seconds = seconds
            }
        }
    }
    
    private func circleView() -> some View {
        ZStack {
            Circle()
                .stroke(.gray
                        ,style: StrokeStyle(lineWidth: 15))
            
            Circle()
                .trim(from: 0, to: CGFloat(1 - CGFloat(seconds) / CGFloat(defaultSeconds)))
                .stroke(defaultSeconds > 0 ? .green.opacity(0.7) : .red.opacity(0.7)
                        ,style: StrokeStyle(lineWidth: 10))
                .rotationEffect(.init(degrees: -90))
                .animation(.bouncy, value: seconds)
            
            circleInnerItemView()
        }
        .frame( width: 250, height: 250)
    }
    
        
    private func circleInnerItemView() -> some View {
        ZStack {
            VStack {
                Spacer()
                Text(convertSecondsToTime(timeInSeconds: seconds))
                    .font(.system(size: 45,weight: .bold))
                    .padding()
                    .onTapGesture {
                        defaultSeconds += 60
                        seconds += 60
                    }
                Spacer()
                    .frame(height: 0)
                
                Button {
                    if seconds != 0  {
                        isPlay.toggle()
                    }
                } label: {
                    Image(systemName: isPlay ? "pause.fill" : "play.fill")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                
                Spacer()
            }
        }
    }
    
    private func minButtonView() -> some View {
        HStack {
            settingButton(time: 60, timeString: "1분")
            settingButton(time: 300, timeString: "5분")
            settingButton(time: 600, timeString: "10분")
            settingButton(timeString: "리셋",initSetting: true)
        }
        .disabled(isPlay ? true : false)

    }
    
    private func settingButton(time: Int = 0, timeString: String = "0분", initSetting: Bool = false) -> some View{
        
        Button {
            if initSetting {
                settingTime(initSetting: true)
            } else {
                settingTime(time)
            }
            
        } label : {
            timeSettingButton(timeText: timeString , color: timeString == "리셋" ? .red : .white)
        }
        .frame(width: 80, height: 30)
        .buttonStyle(PlainButtonStyle())
    }
    
    private func timeSettingButton(timeText: String, color: Color) -> Text{
        Text("\(timeText)")
            .font(.system(size: 20))
            .fontWeight(.bold)
            .foregroundStyle(isPlay ? .gray : color)
    }

    
    private func settingTime(initSetting: Bool = false ,_ settingSec: Int = 0) {
        if initSetting {
            defaultSeconds = settingSec
            seconds = settingSec
        } else {
            defaultSeconds += settingSec
            seconds += settingSec
            
            if defaultSeconds > 3600 {
                defaultSeconds = 0
                seconds = 0
            }
        }
    }
    
    
    
    
    private func convertSecondsToTime(timeInSeconds: Int) -> String {
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02i:%02i", minutes,seconds)
    }
    
    private func playSound(_ soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
