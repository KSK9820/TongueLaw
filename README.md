# Pick픽

> 오늘의 추천작을 만나보세요! 실시간 트랜드 드라마, 영화 컨텐츠를 추천해주는 앱

## 팀원
|최승범|김수경|심소영|
|:--:|:--:|:--:|
|<img src="https://avatars.githubusercontent.com/u/118453865?v=4" width=200>|<img src="https://avatars.githubusercontent.com/u/68066104?v=4" width=200>|<img src="https://avatars.githubusercontent.com/u/152136843?v=4" width=200>|

<br/>

## 프로젝트 환경

- **인원**: iOS 개발자 3명
- **기간**: 2024.10.8 - 2024.10.15
- **최소버전**: iOS 15 +
- 기술 스택
    - **Framework**: UIKit
    - **Reactive Programming**: RxSwift
    - **Architecture**: MVVM(input, output 패턴)
    - **네트워크:** Moya
    - **데이터 관리:** CoreData

## 주요 기능

- `메인 화면` : TMDB API를 통한 트렌드 영화, 시리즈 추천을 조회할 수 있는 화면
    - 추천 영화와 시리즈를 보여주고 mainCell에서는 추천 영화중 랜덤한 화면을 보여줍니다
    - refreshControl을 통해 새롭게 데이터를 받아오는 것이 가능합니다
- `검색 화면` : TMDB API를 활용해서 영화 검색하고 결과를 조회할 수 있는 화면
    - TMDB Search API에 데이터가 있는 경우 한 번에 표시하지 않고 필요할 때에만 네트워크 요청을 해서 paginantion으로 데이터를 추가해서 검색 결과를 조회할 수 있습니다.
    - 데이터가 없는 경우 TMDB Trend API를 사용하여 오늘의 띵작을 조회할 수 있습니다.
- `즐겨찾기 화면` : 즐겨찾기 한 컨텐츠를 확인할 수 있는 화면
    - CoreData에 저장되어 있는 컨텐츠를 조회할 수 있습니다.
- `세부정보 화면` : 영화의 세부 정보를 보여주는 화면
    - 선택한 영화의 포스터, 평점, 개봉일, 줄거리, 출연진 등을 조회할 수 있습니다.
    - 현재 영화와 비슷한 컨텐츠와 추천 컨텐츠를 조회할 수 있습니다.

## 화면
| Home | Search | Favorite | Detail |
| --- | --- | --- | --- |
| <img src="https://github.com/user-attachments/assets/f7c22743-f0aa-4214-a61e-4fd4c9cc0faa" width="300" height="400"> | <img src="https://github.com/user-attachments/assets/b95c3c0a-ce02-41e9-8ead-00ae7de3de5a" width="300" height="400"> | <img src="https://github.com/user-attachments/assets/f57b8dfb-be22-4d5a-b34a-97ea94afa4c0" width="300" height="400"> | <img src="https://github.com/user-attachments/assets/ff32ec83-08a0-4f15-9b0d-d3eff3faead2" width="300" height="400"> |


## 기술스택 상세
- **Router 패턴과 Moya의 TargetType 활용**
    - 네트워크 요청을 모듈화하여 코드 가독성과 유지보수성을 향상시켰습니다.
    - API 엔드포인트를 Router로 관리하여, 새로운 API 추가시 유연한 확장성을 보장하였습니다.
- **CoreData 활용**
    - 사용자가 즐겨찾는 영화와 TV 시리즈를 오프라인에서도 관리할 수 있도록 구현했습니다.
    - 즐겨찾기 목록은 앱 재시작 시에도 유지되며, 저장된 데이터를 손쉽게 조회할 수 있습니다.
- **RxSwift + MVVM 아키텍처**
    - 반응형 프로그래밍으로 비동기 네트워크 처리와 UI 업데이트를 효율적으로 처리합니다.
    - ViewModel과 View의 의존성을 최소화하여 테스트 가능성과 유지보수성을 높였습니다.
- **BaseViewProtocol 생성**
    - BaseViewProtocol을 이용해 UI설정에 있어 통일성이 있는 UI코드를 작성했습니다.
    
    ```swift
    protocol BaseViewProtocol: AnyObject {
        
        func configureView()
        func configureNavigationBar()
        func configureHierarchy()
        func configureUI()
        func configureGestureAndButtonActions()
        func configureLayout()
        
    }
    
    extension BaseViewProtocol {
        
        func configureView() {
            configureNavigationBar()
            configureHierarchy()
            configureUI()
            configureLayout()
            configureGestureAndButtonActions()
        }
    
        func configureNavigationBar() { }
        
        func configureGestureAndButtonActions() { }
        
    }
    ```
    

## 트러블 슈팅
[🚀MVVM으로 변경](https://github.com/KSK9820/TongueLaw/wiki/%ED%8A%B8%EB%9F%AC%EB%B8%94-%EC%8A%88%ED%8C%85-%E2%80%90-View%EC%97%90-%ED%91%9C%EC%8B%9C%ED%95%A0-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%A5%BC-View%EA%B0%80-%EA%B0%80%EC%A7%80%EA%B3%A0-%EC%9E%88%EB%8A%94-%EA%B2%83%EC%9D%B4-%EB%A7%9E%EC%9D%84%EA%B9%8C%3F)
