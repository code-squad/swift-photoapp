## Collection View와 TableView와 공통점 및 차이점
### 공통점
- 셀 재사용(셀 등록 및 dequeing), 사이즈 및 높이 등을 지정하는 방식이 매우 비슷함

### 차이점
- 테이블뷰는 1 dimentional data 표현, 컬렉션뷰는 multi-dimentional data 표현 가능
- 컬렉션뷰는 여러 개의 column이 있는 경우 사용하면 좋다. 가로로 스크롤링이 가능하게 만들 수 있다. (테이블뷰로도 구현은 가능하지만 매우 복잡하다.)
- 또, 컬렉션뷰는 복잡한 레이아웃을 지원한다. ex. UICollectionViewDelegateFlowLayout
- 컬렉션뷰는 drag and drop도 쉽게 구현할 수 있다.
- 컬렉션뷰는 오토 사이징이 정확히 되기 힘든 반면, 테이블뷰는 오토 사이징이 잘 된다.

> [참고: Swift 3: UICollectionView vs UITableView](https://medium.com/@imnitpa/swift-3-uicollectionview-vs-uitableview-9909bbc0ec66)