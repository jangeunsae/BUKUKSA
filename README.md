# BUKUKSA - 부산국제영화제 예매 앱

BUKUKSA는 **부산국제영화제**를 배경으로 한 영화 예매 전용 iOS 애플리케이션입니다.  
직관적인 UI, 사용자 정보 저장, QR코드 발급 등 다양한 기능을 통해 관람객이 간편하게 예매 및 정보를 확인할 수 있도록 도와줍니다.

---

## 어플리케이션 주요 기능

- 로그인 / 회원가입 (UserDefaults 기반)
- 영화 목록 조회 (장르 및 카테고리별 분류)
- 장르별 영화 검색 및 예매
- 예매 정보 저장 및 리스트 제공
- QR코드 예매내역 확인
- 프로필 페이지 (사용자 이름, 예매내역, QR코드)

---

## 프로젝트 구조

```text
BUKUKSA/
├── MainViewController.swift     // 상단 메뉴 버튼으로 뷰 전환 + 메인 영화 리스트
├── ProfileView.swift            // 사용자 이름, 예매 내역, QR 코드 표시
├── SearchingView.swift          // 영화 제목 기반 검색 기능
├── InfoPageViewController.swift// 영화 상세 정보 (제목, 포스터, 줄거리, 평점 등)
├── RegisterView.swift           // 회원가입 UI 및 정보 저장
├── BookingView.swift            // 영화 예매 인원 선택 및 가격 계산
├── LaunchScreen.storyboard     // 앱 실행 시 표시되는 시작화면
├── Assets.xcassets              // QR 이미지, 영화 포스터 등
```

## 사용 기술 및 라이브러리
	•	Swift 5, UIKit, SnapKit
	•	UserDefaults (간단한 사용자/예매 정보 저장)
	•	Kingfisher (TMDB 이미지 로딩)
	•	Alamofire (API 통신 구조 포함, 추후 확장 가능)


## 향후 확장 예정 기능
	•	CoreData 또는 Firebase 기반 사용자 정보 관리
	•	실시간 예매 좌석 시스템 연동
	•	Dark Mode 대응

## 설치 방법
git clone https://github.com/your-username/BUKUKSA.git
cd BUKUKSA
open BUKUKSA.xcodeproj
