# Photos App

## Step1 (시작하기 - CollectionView)
### 요구사항
- Photos 앱 프로젝트 저장소를 본인 저장소로 fork하고 로컬에 clone한다.
- iOS 프로젝트 Single View App 템플릿으로 하고 프로젝트 이름을 "PhotosApp"으로 지정하고, 위에 만든 로컬 저장소 경로에 생성한다.
- 기본 상태로 아이폰 8 시뮬레이터를 골라서 실행한다.
- readme.md 파일을 자신의 프로젝트에 대한 설명으로 변경한다.
    - 단계별로 미션을 해결하고 리뷰를 받고나면 readme.md 파일에 주요 작업 내용(바뀐 화면 이미지, 핵심 기능 설명)과 완성 날짜시간을 기록한다.
    - 실행한 화면을 캡처해서 readme.md 파일에 포함한다.

### 프로그래밍 요구사항
- 스토리보드 ViewController에 CollectionView를 추가하고 Safe 영역에 가득 채우도록 frame을 설정한다.
- CollectionView Cell 크기를 80 x 80 로 지정한다.
- UICollectionViewDataSource 프로토콜을 채택하고 40개 cell을 랜덤한 색상으로 채우도록 구현한다.

### 결과
#### UI
![처음 화면](materials/step1_01.png)

---
## 중간에 고생했던 부분 / 기억할 부분 간단 정리
- CollectionView
    - 테이블 뷰와 유사하지만 좀 더 유연하고 많은 아이템을 배치하여 사용하기에 유용하다.
    
