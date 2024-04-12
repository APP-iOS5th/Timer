//
//  TestSwiftUIView.swift
//  Timer
//
//  Created by user on 4/12/24.
//

import SwiftUI

struct TestSwiftUIView: View  {
    @State private var positionX: CGFloat = -100 // 시작 위치를 화면 왼쪽으로 설정
    private let screenWidth: CGFloat = 100 // 화면의 가로 길이

    var body: some View {
        Image(systemName: "cat")
            .offset(x: positionX, y: 0) // X 좌표만 변경하여 애니메이션 적용
            .onAppear {
                // 타이머 시작
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                    // 동물 아이콘을 오른쪽으로 이동시키는 애니메이션
                    withAnimation(.linear(duration: 1.5)) {
                        positionX = screenWidth + 100 // 화면 오른쪽을 벗어나는 위치로 설정
                    }
                }
            }
    }
}
#Preview {
    TestSwiftUIView()
}
