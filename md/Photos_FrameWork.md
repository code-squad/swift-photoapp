# Photos FrameWork
## 제공 기능

- Interacting with the Photos Library : shared 오브젝트를 사용해서 유저의 퍼미션을 얻거나 변경을 하거나, 변경을 관찰하기 위해 register 하는 등에 사용됨
	- PHPhotoLibrary
- Retrieving and Examining Assets : Photos 라이브러리의 콘텐츠를 나타내는 모델 클래스들. 읽기전용, 변경불가, 메타데이터만 담고 있다. 데이터를 fetch할 때 사용.
	- PHAsset
	- PHAssetCollection
	- PHCollectionList
	- PHCollection
	- PHFetchResult
	- PHImageManager
	- 등
- Loading Asset Content : Asset을 이미지, 비디오, 라이브 포토 등으로 받고자 할 때 사용한다. 이미지를 자동으로 다운로드하고, image로 생성하며, 재사용을 위해 캐싱해주기도 한다. 또, 대량의 이미지를 다룰 땐 빠른 성능을 위해 preload 기능도 있다.
	- PHImageManager
	- PHCachingImageManager
	- 등
- Requesting Changes : asset이나 collection을 변경하고자 할 때, change request object를 생성하고 수정사항을 반영하여 Photos 라이브러리에 커밋하면 된다.
	- PHAssetChangeRequest
	- PHAssetCollectionChangeRequest
	- PHCollectionListChangeRequest
	- PHObjectPlaceholder
- Editing Asset Content : asset 데이터를 수정할 때 사용한다. 
	- PHContentEditingInput
	- PHContentEditingOutput
	- PHAdjustmentData
	- 등
- Observing Changes : Photos는 다른 앱이나 기기, 또는 현재 앱의 특정 코드에서 asset이나 collection 콘텐츠나 메타데이터가 변경된 경우, 이를 알려준다. 변경 전/후의 object 상태를 알려준다.
	- PHPhotoLibraryChangeObserver 프로토콜
	- PHChange : Photos 라이브러리에서의 변경사항
	- PHObjectChangeDetails : 하나의 asset이나 collection에서의 변경사항
	- PHFetchResultChangeDetails : fetch result에서의 변경사항

## 주요 자료구조 클래스
### PHAsset
- 낱개의 사진이나 동영상을 표현하는 클래스로, 메타데이터만 담는다.
- fetchAssets(in:options:) 메소드를 통해 사진첩에서 가져올 수 있다.
- 수정 불가능한 Immutable 타입으로, PHAssetChangeRequest를 통해 수정할 수 있다.
- PHImageManager를 통해 이미지로 변환할 수 있다.

### PHAssetCollection
- PHAsset을 모아둔 개념으로, 각각의 앨범을 담는 클래스이다. (사용자 생성 앨범, Moment 앨범 등)
- fetchAssets(in:options:) 메소드를 통해 사진첩에서 가져올 수 있다.
- 수정 불가능한 Immutable 타입으로, PHAssetCollectionChangeRequest를 통해 수정할 수 있다.

### PHCollectionList
- PHAssetCollection을 모아둔 개념으로, 앨범 리스트를 나타낸다.
- fetchCollections(in:options:) 메소드를 통해 사진첩에서 가져올 수 있다.
- 수정 불가능한 Immutable 타입으로, PHCollectionListChangeRequest를 통해 수정할 수 있다.

### PHCollection
- PHAssetCollection, PHCollectionList가 상속받은 추상 클래스
- 두 클래스에서 공통으로 사용하는 메소드가 선언돼 있다.

### PHObject
- asset이나 collection의 추상 클래스
- isEqual(), hash 메소드를 구현하고 있기 때문에, localIdentifier를 통해 object 들을 구분할 수 있다.

### PHFetchResult
- fetch 메소드를 통해 가져온 정렬된 asset이나 collection의 리스트이다. 즉, 사진을 담는 배열 클래스라고 보면 된다.
- 따라서 NSArray와 비슷한 기능을 가지고 있다.

### PHImageManager
- asset이나 thumbnail을 조회하거나 생성하는 메소드를 제공한다.
- 예를 들어, PHAsset을 받아서 UIImage로 변경시켜준다든지..


[참고: Apple Developer Document](https://developer.apple.com/documentation/photos)

[참고: 고무망치의 Dev N Life](http://rhammer.tistory.com/229?category=503774)