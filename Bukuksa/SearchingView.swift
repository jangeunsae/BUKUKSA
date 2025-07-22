//
//  SearchingView.swift
//  Bukuksa
//
//  Created by 장은새 on 7/15/25.
//

import Foundation
import UIKit
import SnapKit

class SearchingView: UIView, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    enum MovieCategory: String, CaseIterable {
        case nowPlaying = "now_playing"
        case popular = "popular"
        case topRated = "top_rated"
        case upcoming = "upcoming"
    }
    
    private let searchTextField = UITextField()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    //API를 구현해서 텍스트필드에 입력된 값의 영화제목의 이미지를 가져와야함
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(searchTextField)
        addSubview(collectionView)
        
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        searchTextField.borderStyle = .roundedRect
        searchTextField.placeholder = "Search"
        searchTextField.isHidden = true
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(60)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(160)
        }
        fetchMoives {
            self.searchTextField.isHidden = true
            self.searchTextField.becomeFirstResponder()
            self.filterSearchResults(text: self.searchTextField.text ?? "")
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        _ = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        filterSearchResults(text: textField.text ?? "")
        return true
    }
    
    
    
    private func filterSearchResults(text: String) {
        filteredMovies = movies.filter { movie in movie.title.lowercased().contains(text.lowercased()) }
        collectionView.reloadData()
        collectionView.isHidden = filteredMovies.isEmpty
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { subview in subview.removeFromSuperview() }
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.numberOfLines = 2
        
        cell.contentView.addSubview(imageView)
        cell.contentView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        let movie = filteredMovies[indexPath.item]
        titleLabel.text = movie.title
        
        if let posterPath = movie.poster_path {
            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                    }
                }.resume()
            }
        } else {
            imageView.image = nil
        }
        
        return cell
    }
    
    struct Movie: Codable {
        let title: String
        let poster_path: String?
    }
    
    struct MovieResponse: Codable {
        let results: [Movie]
    }
    
    func fetchMoives(completion: (() -> Void)? = nil) {
        let apiKey = "bbbd0e19cbdae7622268c7375e59a38e"
        let categories: [MovieCategory] = MovieCategory.allCases
        var allMovies: [Movie] = []
        var completedCount = 0
        
        for category in categories {
            let urlString = "https://api.themoviedb.org/3/movie/\(category.rawValue)?api_key=\(apiKey)&language=ko-KR&page=1"
            guard let url = URL(string: urlString) else {
                completedCount += 1
                continue
            }
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                if let data = data {
                    if let decoded = try? JSONDecoder().decode(MovieResponse.self, from: data) {
                        allMovies.append(contentsOf: decoded.results)
                    }
                }
                completedCount += 1
                if completedCount == categories.count {
                    DispatchQueue.main.async {
                        self?.movies = allMovies
                        completion?()
                    }
                }
            }.resume()
        }
    }
    
    public func showSearchTextField() {
        searchTextField.isHidden = false
        if !filteredMovies.isEmpty {
            collectionView.isHidden = false
        }
    }
    public func hideSearchTextField() {
        searchTextField.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        filterSearchResults(text: textField.text ?? "")
        return true
    }
    public func hideSearchResults() {
        collectionView.isHidden = true
    }
}
