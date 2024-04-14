//
//  ContentView.swift
//  TIMER_T
//
//  Created by Mac on 4/12/24.
//
import SwiftUI
import AVFoundation

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let rgbValue = UInt32(hex, radix: 16)
        let r = Double((rgbValue! & 0xFF0000) >> 16) / 255
        let g = Double((rgbValue! & 0x00FF00) >> 8) / 255
        let b = Double(rgbValue! & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
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
    @State var selectedView = 1
    @State private var currentTimer: Double = 60.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Image("PieceOfCookieIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Spacer()
                        Text("0:00")
                            .fontWeight(.regular)
                            .font(Font.system(size: 40))
                            .foregroundColor(.black)
                    }
                    .padding()
                    Spacer()
                    Spacer()
                    
                    VStack{
                        ZStack {
                            Circle()
                                .stroke(Color.black, lineWidth: 35)
                                .fill(.clear)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70)
                            Image(systemName: "pause")
                                .font(Font.system(size: 20))
                                .fontWeight(.black)
                                .foregroundStyle(.black)
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        VStack{
                            HStack{
                                NavigationLink{
                                    ContentView()
                                } label : {
                                    Image("SettingIcon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 15, height: 20)
                                    Text(" Timer ")
                                        .foregroundStyle(.black)
                                        .tag(1)
                                    
                                    NavigationLink{
                                        PresetListView()
                                    } label : {
                                        Image("Cookies Button")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                        Text(" Cookies ")
                                            .foregroundStyle(Color(hex: "#8E959F"))
                                            .tag(2)
                                    }
                                }
                            }
                        }
                        .accentColor(Color(hex: "#8E959F"))
                        Spacer()
                    }
                }
            }
            
            .frame(width: 198, height: 242)
            .background(Color(hex: "#EDEFF3"))
            .ignoresSafeArea()
        }
    }
    
    func runTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            currentTimer -= 1
            if currentTimer < 0 {
                currentTimer = 60
                timer.invalidate()
            }
        }
        
    }
    
    
    struct PresetModel: Identifiable {
        var id: UUID = UUID()
        let timerDuration: String
    }
    
    struct PresetListView: View {
        
        let presets: [PresetModel] = [
            PresetModel(timerDuration: "3:00"),
            PresetModel(timerDuration: "5:00"),
            PresetModel(timerDuration: "7:00"),
            PresetModel(timerDuration: "10:00"),
        ]
        
        
        var body: some View {
            List(presets) { preset in
                HStack {
                    Text("\(preset.timerDuration)")
                        .font(Font.system(size: 20))
                        .fontWeight(.medium)
                    Spacer()
                    Button(action: {
                        print("Started \(preset.timerDuration)")
                    }, label: {
                        Text("시작")
                    })
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    NavigationLink(destination: PresetAddView()) {
                        Image(systemName: "plus")
                    }
                }
            }
            
        }
        
    }
    
    struct PresetAddView: View {
        @State private var minute: Int = 0
        @State private var second: Int = 0
        
        var body: some View {
            VStack {
                HStack{
                    Picker(selection: $minute) {
                        ForEach(0...60, id: \.self) { min in
                            Text("\(minute)분")
                        }
                    } label: {
                        Text("\(minute)분")
                    }
                    Picker(selection: $minute) {
                        ForEach(0...60, id: \.self) { min in
                            Text("\(second)초")
                        }
                    } label: {
                        Text("\(second)초")
                    }
                }
                .frame(height: 80)
                
                Button(action: {
                    
                }, label: {
                    Text("타이머 저장")
                })
            }
        }
    }
}

#Preview {
    ContentView()
}
