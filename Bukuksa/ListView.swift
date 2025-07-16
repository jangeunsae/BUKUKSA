//
//  ListView.swift
//  Bukuksa
//
//  Created by 장은새 on 7/15/25.
//


import UIKit
import SnapKit

class ListView: UIViewController {
    
    // MARK: - UI 요소들
    
    private let bannerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bannerImage")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let categoryTitles = ["인기 영화", "현재 상영작", "평점 높은 작품", "개봉 예정작"]
    private var categoryButtons: [UIButton] = []
    private var collectionViews: [UICollectionView] = []
    
    private let dummyMovieCount = 10
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupLayouts()
        setupCollectionViews()
    }
    
    // MARK: - UI 구성
    
    private func setupViews() {
        view.addSubview(bannerImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        for title in categoryTitles {
            let btn = UIButton(type: .system)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            btn.layer.cornerRadius = 15
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.systemGray4.cgColor
            btn.setTitleColor(.black, for: .normal)
            btn.backgroundColor = .white
            btn.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            categoryButtons.append(btn)
            contentView.addSubview(btn)
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .clear
            cv.showsHorizontalScrollIndicator = false
            cv.dataSource = self
            cv.delegate = self
            cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
            collectionViews.append(cv)
            contentView.addSubview(cv)
        }
    }
    
    private func setupLayouts() {
        bannerImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10) // ← 로고 없앴으므로 바로 top
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(150)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(bannerImageView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        var previousBottom = contentView.snp.top
        
        for i in 0..<categoryButtons.count {
            let btn = categoryButtons[i]
            let cv = collectionViews[i]
            
            btn.snp.makeConstraints {
                $0.top.equalTo(previousBottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(120)
                $0.height.equalTo(35)
            }
            
            cv.snp.makeConstraints {
                $0.top.equalTo(btn.snp.bottom).offset(10)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(180)
            }
            
            previousBottom = cv.snp.bottom
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(previousBottom).offset(20)
        }
    }
    
    private func setupCollectionViews() {
        // 초기 UI 설정
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        guard let index = categoryButtons.firstIndex(of: sender) else { return }
        selectCategoryButton(at: index)
    }
    
    private func selectCategoryButton(at index: Int) {
        for (i, btn) in categoryButtons.enumerated() {
            if i == index {
                btn.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
                btn.layer.borderColor = UIColor.systemBlue.cgColor
                btn.setTitleColor(.systemBlue, for: .normal)
            } else {
                btn.backgroundColor = .white
                btn.layer.borderColor = UIColor.systemGray4.cgColor
                btn.setTitleColor(.black, for: .normal)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, Delegate

extension ListView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dummyMovieCount
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
