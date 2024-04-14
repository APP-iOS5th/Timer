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
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Image("PieceOfCookieIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        Spacer()
                        Text("0:00")
                            .fontWeight(.medium)
                            .font(Font.system(size: 40))
                            .foregroundColor(.black)
                    }
                    .padding()
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
                        VStack{
                            TabView(selection: $selectedView) {
                                Text("Timer")
                                    .foregroundColor(.black)
                                    
                                    .tabItem {
                                        Text("Timer")
                                            .foregroundColor(.black)
                                        Image("SettingIcon")
                                        
                                    }.tag(1)
                                Image("Cookies Button")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.black)
                                    .tabItem {
                                        
                                        Text("Cookies")
                                    }.tag(2)
                            }
                            
                            /*
                            NavigationLink{
                                PresetListView()
                            } label: {
                                Text("Show Presets")
                            }
                             */
                        }
                    }
                }
                    .frame(width: 198, height: 242)
                    .background(Color(hex: "#EDEFF3"))
                    .ignoresSafeArea()
            }
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
                            Spacer()
                            Button(action: {
                                print("Started \(preset.timerDuration)")
                            }, label: {
                                Text("Start")
                            })
               
                }
            }
        }
    }

#Preview {
    ContentView()
}
