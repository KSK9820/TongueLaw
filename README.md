# Pick픽

> 오늘의 추천작을 만나보세요! 실시간 트랜드 드라마, 영화 컨텐츠를 추천해주는 앱

## 팀원
|최승범|김수경|심소영|
|:--:|:--:|:--:|
|<img src="https://avatars.githubusercontent.com/u/118453865?v=4" width=200>|<img src="https://avatars.githubusercontent.com/u/68066104?v=4" width=200>|<img src="https://avatars.githubusercontent.com/u/152136843?v=4" width=200>|
| UI 컴포넌트 설계 및 구현<br/>&<br/>HomeView 로직 및 화면 연동 | 코어데이터 모델 설계 및 구현<br/>&<br/>SearchView 로직 및 화면 연동 | 네트워크 시스템 설계 및 구현<br/>&<br/>DetailView 로직 및 화면 연동 |

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
- **Router Pattern과 Moya의 TargetType 활용**
    - 네트워크 설계시에 Router Pattern을 사용한 이유로는
        - 네트워크 요청을 모듈화하여 코드 가독성과 유지보수성을 향상시켰습니다.
        - API 엔드포인트를 Router로 관리하여, 새로운 API 추가시 유연한 확장성을 보장할 수 있기 때문에 Router Pattern을 사용하였습니다.
    - Moya 라이브러리를 사용한 이유로는
        - Moya는 API 요청을 TargetType 프로토콜로 정의하기 때문에 모든 요청을 일관된 구조로 관리하기 때문에 API 요청이 명확하게 구성되고, 중복된 코드를 줄이며 코드의 가독성을 높일 수 있습니다.
        - Moya는 명확한 패턴을 제공하기 때문에 팀원 간의 협업 시 API 요청 처리 방식에 있어 일관성을 유지할 수 있기 때문에 Moya를 사용하였습니다.
- **CoreData 활용**
    - 사용자가 즐겨찾는 영화와 TV 시리즈를 오프라인에서도 관리할 수 있도록 구현했습니다.
    - 오프라인에서 데이터를 관리하는 방법으로 CoreData를 사용한 이유로는
      - UserDefaults는 기본적으로 앱이 실행될 때 메모리에 데이터를 로드하기 때문에 필요할 때마다 읽는 방식이 아니기 때문에 사용하지 않았습니다.
      - Realm에 의존하면 특정 API와 데이터 모델에 종속성이 생기는 것을 피하고자 사용하지 않았습니다.
    - Core Data는 iOS의 네이티브 솔루션이고, 객체의 속성을 처음 접근할 때만 데이터를 로드하는 Faulting 메커니즘을 사용하기 때문에 필요한 시점에만 속성 값을 불러와 메모리 효율성을 극대화합니다.
    - 또한 Core Data는 각 객체의 변경 사항을 자동으로 추적하여서 객체가 수정되면 해당 변경 사항이 자동으로 기록되고, 별도의 저장 프로세스를 거쳐 데이터베이스에 반영할 수 있기 때문에 CoreData를 사용하였습니다.
- **RxSwift + MVVM 아키텍처**
    - 반응형 프로그래밍인 RxSwift를 사용한 이유로는
      - 데이터 흐름의 변화를 바로 파악할 수 있어 네트워크 결과와 같이 비동기적인 작업의 응답에 즉각적으로 UI 업데이트를 할 수 있습니다.
      - RxCocoa를 통해 사용자 이벤트를 처리할 수 있어서 UI와 로직의 결합을 효율적으로 처리할 수 있기 때문에 RxSwift를 사용하였습니다.
    - MVVM을 사용한 이유로는
      - UI와 로직 간의 결합을 최소화할 수 있습니다.
      - 추후 리팩토링시 테스트 가능한 코드를 작성하여 테스트에 용이하기 때문입니다.
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
