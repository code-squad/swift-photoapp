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