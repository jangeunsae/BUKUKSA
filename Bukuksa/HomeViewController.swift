//
//  ViewController.swift
//  Bukuksa
//
//  Created by 장은새 on 7/15/25.
//
import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    let movieListButton = UIButton(type: .system)
    let searchButton = UIButton(type: .system)
    let profileButton = UIButton(type: .system)
    
    let movieListUnderline = UIView()
    let searchUnderline = UIView()
    let profileUnderline = UIView()
    
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "BannerImage")
        imageView.image = image
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let categoryTitles = ["인기 영화", "현재 상영작", "평점 높은 작품", "개봉 예정작"]
    private var categoryButtons: [UIButton] = []
    private var collectionViews: [UICollectionView] = []
    
    private let dummyMovieCount = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupButtons()
        setupListView()
        updateSelectedButton(movieListButton)
    }
    
    private func setupButtons() {
        let buttonStack = UIStackView(arrangedSubviews: [movieListButton, searchButton, profileButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        
        view.addSubview(buttonStack)
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5) // safeArea 기준으로 위치 조정
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        movieListButton.setTitle("영화목록", for: .normal)
        searchButton.setTitle("영화검색", for: .normal)
        profileButton.setTitle("마이페이지", for: .normal)
        
        movieListButton.addTarget(self, action: #selector(showMovieList), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
        
        [movieListUnderline, searchUnderline, profileUnderline].forEach {
            $0.backgroundColor = .systemBlue
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        movieListButton.addSubview(movieListUnderline)
        searchButton.addSubview(searchUnderline)
        profileButton.addSubview(profileUnderline)
        
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
    
    private func setupListView() {
        view.addSubview(bannerImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        bannerImageView.snp.makeConstraints { make in
            make.top.equalTo(movieListButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(150)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        var previousBottom = contentView.snp.top
        
        for title in categoryTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            
            categoryButtons.append(button)
            contentView.addSubview(button)
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
            
            collectionViews.append(collectionView)
            contentView.addSubview(collectionView)
            
            button.snp.makeConstraints { make in
                make.top.equalTo(previousBottom).offset(20)
                make.centerX.equalToSuperview()
                make.width.equalTo(120)
                make.height.equalTo(35)
            }
            
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(button.snp.bottom).offset(10)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(180)
            }
            
            previousBottom = collectionView.snp.bottom
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(previousBottom).offset(20)
        }
    }
    
    @objc private func showMovieList() {
        updateSelectedButton(movieListButton)
        clearListView()
        setupListView()  // ← 리스트 화면 다시 구성
    }
    
    @objc private func showSearch() {
        updateSelectedButton(searchButton)
        clearListView()
        // 검색 화면 추가 가능
    }

    @objc private func showProfile() {
        updateSelectedButton(profileButton)
        clearListView()
        // 프로필 화면 추가 가능
    }
    private func clearListView() {
        scrollView.removeFromSuperview()
        bannerImageView.removeFromSuperview()
        categoryButtons.removeAll()
        collectionViews.removeAll()
    }

    private func updateSelectedButton(_ selectedButton: UIButton) {
        [movieListButton, searchButton, profileButton].forEach { button in
            button.setTitleColor(.black, for: .normal)
        }
        movieListUnderline.isHidden = movieListButton != selectedButton
        searchUnderline.isHidden = searchButton != selectedButton
        profileUnderline.isHidden = profileButton != selectedButton
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        guard let index = categoryButtons.firstIndex(of: sender) else { return }
        for (i, button) in categoryButtons.enumerated() {
            if i == index {
                button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
                button.layer.borderColor = UIColor.systemBlue.cgColor
                button.setTitleColor(.systemBlue, for: .normal)
            } else {
                button.backgroundColor = .white
                button.layer.borderColor = UIColor.systemGray4.cgColor
                button.setTitleColor(.black, for: .normal)
            }
        }
    }
}

// MARK: - UICollectionView 설정

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyMovieCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        cell.configure(index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 170)
    }
}
class MovieCell: UICollectionViewCell {
    
    static let identifier = "MovieCell"
    
    private let posterImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.clipsToBounds = true
    }
    
    func configure(index: Int) {
        // 나중에 이미지 URL 넣는 식으로 변경 가능
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
