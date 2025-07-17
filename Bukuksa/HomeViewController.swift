//
//  ViewController.swift
//  Bukuksa
//
//  Created by 장은새 on 7/15/25.
//
import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private let searchingView = SearchingView()
   
    // 제목 레이블
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "bukuksa"  // 제목 텍스트 설정
        label.font = UIFont.boldSystemFont(ofSize: 20)  // 굵은 글씨, 크기 20
        label.textColor = UIColor.systemBlue  // 파란색 텍스트
        return label
    }()

    // 버튼들
    let movieListButton = UIButton(type: .system)
    let searchButton = UIButton(type: .system)
    let profileButton = UIButton(type: .system)

    // 버튼 밑줄 뷰들
    let movieListUnderline = UIView()
    let searchUnderline = UIView()
    let profileUnderline = UIView()
    
    // 컨텐츠를 담을 뷰
    let containerView = UIView()

    // bukuksa 이미지 뷰
    let bokuksaImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bukuksa")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(searchingView)
        searchingView.snp.makeConstraints { make in            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        // 이미지 뷰 및 제목 레이블 추가
        view.addSubview(bokuksaImageView)
        view.addSubview(titleLabel)
        bokuksaImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)  // 안전 영역 위에서 5pt 아래
            make.leading.equalToSuperview().offset(40)  // 왼쪽에서 40pt 떨어짐
            make.height.width.equalTo(50)  // 50x50 크기
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(bokuksaImageView.snp.trailing).offset(8)  // 이미지 오른쪽 8pt 띄움
            make.centerY.equalTo(bokuksaImageView)  // 이미지와 수직 가운데 정렬
        }

        setupButtons()  // 버튼 설정
        setupContainerView()  // 컨테이너 뷰 설정
        updateSelectedButton(movieListButton)  // 초기 선택 상태
        showMovieList()  // 초기 화면: 영화목록
    }

    func setupButtons() {
        // 버튼들을 수평 스택뷰에 담기
        let buttonStack = UIStackView(arrangedSubviews: [movieListButton, searchButton, profileButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually

        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(bokuksaImageView.snp.bottom).offset(20)  // 이미지 아래 20pt
            $0.leading.trailing.equalToSuperview()  // 좌우 꽉 채움
            $0.height.equalTo(44)  // 높이 44pt
        }

        // 버튼 타이틀 설정
        movieListButton.setTitle("영화목록", for: .normal)
        searchButton.setTitle("영화검색", for: .normal)
        profileButton.setTitle("마이페이지", for: .normal)

        // 버튼 액션 연결
        movieListButton.addTarget(self, action: #selector(showMovieList), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(showProfile), for: .touchUpInside)

        // 밑줄 뷰 초기 설정
        [movieListUnderline, searchUnderline, profileUnderline].forEach {
            $0.backgroundColor = .systemBlue
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // 각 버튼에 밑줄 뷰 추가
        movieListButton.addSubview(movieListUnderline)
        searchButton.addSubview(searchUnderline)
        profileButton.addSubview(profileUnderline)

        // 밑줄 위치 및 크기 제약
        NSLayoutConstraint.activate([
            movieListUnderline.heightAnchor.constraint(equalToConstant: 2),
            movieListUnderline.leadingAnchor.constraint(equalTo: movieListButton.leadingAnchor),
            movieListUnderline.trailingAnchor.constraint(equalTo: movieListButton.trailingAnchor),
            movieListUnderline.bottomAnchor.constraint(equalTo: movieListButton.bottomAnchor),

            searchUnderline.heightAnchor.constraint(equalToConstant: 2),
            searchUnderline.leadingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            searchUnderline.trailingAnchor.constraint(equalTo: searchButton.trailingAnchor),
            searchUnderline.bottomAnchor.constraint(equalTo: searchButton.bottomAnchor),

            profileUnderline.heightAnchor.constraint(equalToConstant: 2),
            profileUnderline.leadingAnchor.constraint(equalTo: profileButton.leadingAnchor),
            profileUnderline.trailingAnchor.constraint(equalTo: profileButton.trailingAnchor),
            profileUnderline.bottomAnchor.constraint(equalTo: profileButton.bottomAnchor),
        ])
    }

    func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: movieListButton.bottomAnchor),  // 버튼 아래에 위치
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // 자식 뷰컨트롤러 및 서브뷰 모두 제거하는 함수
    private func removeAllChildren() {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        containerView.subviews.forEach { $0.removeFromSuperview() }
    }

    @objc func showSearch() {
        updateSelectedButton(searchButton)  // 선택 상태 업데이트
        removeAllChildren()  // 기존 뷰 제거
        searchingView.showSearchTextField()
        
    }

    @objc func showProfile() {
        updateSelectedButton(profileButton)  // 선택 상태 업데이트
        removeAllChildren()  // 기존 뷰 제거
        searchingView.hideSearchTextField()// 빈 화면 상태 유지 (프로필 뷰 추가 가능)
    }

    @objc func showMovieList() {
        updateSelectedButton(movieListButton)  // 선택 상태 업데이트
        removeAllChildren()
        searchingView.hideSearchTextField()// 기존 뷰 제거

        // 영화목록 뷰컨트롤러 추가
        let listVC = ListView()
        addChild(listVC)
        listVC.view.frame = containerView.bounds
        containerView.addSubview(listVC.view)
        listVC.didMove(toParent: self)
    }

    // 선택된 버튼 표시, 밑줄 표시 상태 업데이트
    func updateSelectedButton(_ selectedButton: UIButton) {
        [movieListButton, searchButton, profileButton].forEach {
            $0.backgroundColor = .white  // 모두 흰색 배경
            $0.setTitleColor(.black, for: .normal)  // 모두 검은색 텍스트
        }

        movieListUnderline.isHidden = movieListButton != selectedButton
        searchUnderline.isHidden = searchButton != selectedButton
        profileUnderline.isHidden = profileButton != selectedButton
    }
}
