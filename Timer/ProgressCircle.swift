import SwiftUI


struct ProgressCircle: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke()
            
            Circle()
        }
    }
}


struct Progress_Preview: PreviewProvider {
    static var previews: some View {
        ProgressCircle()
    }
}
