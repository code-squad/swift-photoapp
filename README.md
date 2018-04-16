# Photo App

## CollectionView 생성
![](img/photoapp_step1.png)

### CollectionView를 화면에 꽉 채우고, 40개 cell을 랜덤 색상으로 채움
- 시뮬레이터: iPhone 8

### 랜덤 색상 적용 시
- `drand48()` : 0~1 사이 범위 내에서 랜덤 숫자 생성
- UIColor.init()의 RGB 값은 0~1 사이 값을 가지므로, 보통 색상 지정 시 실제 RGB 값을 255로 나눔.
- 랜덤 색상 적용 시에는 0~1 사이의 랜덤 수를 생성하면 되므로, drand48()을 사용함

```swift
static var random: UIColor {
	return UIColor.init(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
}
```

### 학습 내용
>- **[Collection View 프로그래밍 방식]()**
>- **[Collection View와 TableView와 공통점 및 차이점]()**

2018-04-13 (작업시간: 1일)

<br/>