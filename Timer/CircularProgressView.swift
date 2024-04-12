import Foundation
import SwiftUI

struct CircularProgressView: View {
    @Binding var progress: Float

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8.0)
                .opacity(0.3)
                .foregroundColor(Color("TimerButtonCancel"))
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("TimerButtonPause"))
                .rotationEffect(Angle(degrees: 270))
        }
        .animation(.linear(duration: 1.0), value: progress)
    }
}
