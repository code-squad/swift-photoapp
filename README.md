# Photos 사진앱

## step01. CollectionView

### 배운내용

#### UICollectionViewDelegateFlowLayout의 'func collectionView(_:layout:sizeForItemAt) -> CGSize'를 사용하면 셀의 크기를 조절할 수 있습니다.

### 실행화면

<img width="400" src="https://user-images.githubusercontent.com/38850628/59339120-8e83c580-8d3e-11e9-8fa5-bf95c83a83a3.gif">

## step02. Photos 라이브러리

### 배운내용

#### PHCachingImageManager

PHCachingImageManager는 PHImageManager를 상속받은 객체.
`startCachingImages`등의 메서드로 preheat 가능

#### PHPhotoLibrary 클래스에 사진보관함이 변경되는지 여부 등록

1. PHPhotoLibraryChangeObserver 채택, 준수
2. PHPhotoLibrary.shared().register(self)

### 실행화면

<img width="400" src="https://user-images.githubusercontent.com/38850628/59559640-03f3dc80-9044-11e9-810c-3b3f1d2cda60.gif">

<img width="400" src="https://user-images.githubusercontent.com/38850628/59561105-e7ad6b00-9056-11e9-8025-0aa4ed238428.gif">

## step03. AVAssetWriter로 동영상 만들기

### 배운내용

#### PHLivePhotoView에 Live Photo Badge가 있다는것을 배움

#### CollectionView의 allowsMultipleSelection을 true로 바꾸면 다중 선택 가능

### 실행화면

<img width="400" src="https://user-images.githubusercontent.com/38850628/59749600-4d4c6200-92b8-11e9-9330-476ab544c428.gif">

## step04. GCD 작업 스케줄링

### 배운내용

#### UIMenuItem 사용법에 대해서 배움

```swift
self.becomeFirstResponder()
let menuItem = UIMenuItem(title: "Save", action: .saveMenuItemDidTap)
UIMenuController.shared.menuItems = [menuItem]
guard let superView = self.superview else { return }
UIMenuController.shared.setTargetRect(self.frame, in: superView)
UIMenuController.shared.setMenuVisible(true, animated: true)
```
```swift
override var canBecomeFirstResponder: Bool {
    return true
}

override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == .saveMenuItemDidTap {
        return true
    }
    return false
}
```

#### 이미지를 앨범에 저장하는 방법을 배움

```swift
UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
```

#### UILongPressGestureRecognizer가 2번 인식하길래 아래처럼 해결

```swift
@objc func targetDidLongPress(sender: UILongPressGestureRecognizer) {
    if sender.state == .began {
    }
}
``` 

### 실행화면

<img width="400" src="https://user-images.githubusercontent.com/38850628/59860900-c3d18880-93ba-11e9-96c8-e2a701d5f083.gif">

## step05. Core Image 필더 적용하기

### 배운내용

#### 필터 적용 여부 파악하는 법을 배움

```swift
PHAssetResource.assetResources(for: asset).filter { $0.type == .adjustmentData }
```

### 실행화면

<img width="400" src="https://user-images.githubusercontent.com/38850628/60394553-2e27bd00-9b61-11e9-8add-038dd8717689.gif">

<img width="400" src="https://user-images.githubusercontent.com/38850628/60394554-2e27bd00-9b61-11e9-822b-f4b292577fb2.gif">

<img width="400" src="https://user-images.githubusercontent.com/38850628/60394552-2d8f2680-9b61-11e9-83be-f0b7b37b2277.gif">
