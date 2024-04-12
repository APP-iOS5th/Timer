10초 증감 타이머
=============

![alt text](image.png)
![alt text](image-1.png)
<img src="image.png" width="50"/>
<img src="image-1png" width="50"/>

- 좌표이동 애니메이션 용 아이콘 : airplane
- 종료임박 애니메이션 용 아이콘 : airplane.arrival
- 1초에 한번씩 x좌표 +1 씩이동
- 남은 시간 10초 이하일 시, airplane.arrival로 바뀜


## 변수

```swift
private let MAX_TIME = 1 * 60 // 1
private let MIN_TIME = 0 // 2
private let TIMER_VALUE = 10 // 3
```

1. 타이머의 최대치
2. 타이머의 최소치
3. 타이머의 증가감 수치


## 함수

```swift
// 1
func plusButtonActionCheckMaxTime() {
    if(timeRemaining > MAX_TIME - TIMER_VALUE) {
        timeRemaining = MAX_TIME
    } else {
        timeRemaining += TIMER_VALUE
    }
}

//2
func minusButtonActionCheckMinTime() {
    if(timeRemaining < (MIN_TIME + TIMER_VALUE)) {
        timeRemaining = MIN_TIME
        print("Minus Button : \(timeRemaining)")
    } else {
        timeRemaining -= TIMER_VALUE
    }
}
```
1. 플러스 버튼 액션
 - timeRemaining의 값이 최대치 이상으로 올라가지 않도록 방지
 - TIMER_VALUE(증가감 수치)의 값 만큼 timeRemaining의 값이 변경되도록 실행
2. 마이너스 버튼 액션
 - timeRemaining의 값이 최소치 이하로 내려가지 않도록 방지
 - TIMER_VALUE(증가감 수치)의 값 만큼 timeRemaining의 값이 변경되도록 실행



