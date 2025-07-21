// ViewController.swift
// Bukuksa
//
// Created by 장은새 on 7/15/25.
//
import UIKit
import SnapKit
class HomeViewController: UIViewController {
    
    let searchingView = SearchingView()
    let profileView = ProfileView()
    // 상단 버튼들
    let movieListButton = UIButton(type: .system)
    let searchButton = UIButton(type: .system)
    let profileButton = UIButton(type: .system)
    let movieListUnderline = UIView()
    let searchUnderline = UIView()
    let profileUnderline = UIView()
    // 배너 이미지
    let bannerImageView = UIImageView()
    // 스크롤 영역
    let scrollView = UIScrollView()
    let contentView = UIView()
    // 카테고리 버튼 & 영화 목록
    let categoryTitles = ["인기 영화", "현재 상영작", "평점 높은 작품", "개봉 예정작"]
    var categoryButtons: [UIButton] = []
    var collectionViews: [UICollectionView] = []
    var movieLists: [[MovieData]] = [[], [], [], []]
    let dummyMovieCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTopButtons()
        setupMovieListView()
        updateSelectedButton(movieListButton)
        searchingView.hideSearchTextField()
        
        view.addSubview(searchingView)
        searchingView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(100)
        }
    }
    // MARK: - 상단 버튼 UI
    func setupTopButtons() {
        let stackView = UIStackView(arrangedSubviews: [movieListButton, searchButton, profileButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        movieListButton.setTitle("영화목록", for: .normal)
        searchButton.setTitle("영화검색", for: .normal)
        profileButton.setTitle("마이페이지", for: .normal)
        movieListButton.addTarget(self, action: #selector(showMovieList), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
        movieListUnderline.backgroundColor = .systemBlue
        searchUnderline.backgroundColor = .systemBlue
        profileUnderline.backgroundColor = .systemBlue
        [movieListUnderline, searchUnderline, profileUnderline].forEach {
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
    // MARK: - 영화 목록 구성
    func setupMovieListView() {
        // 배너 이미지 설정
        bannerImageView.image = UIImage(named: "BannerImage")
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerImageView.layer.cornerRadius = 8
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
        var lastViewBottom = contentView.snp.top
        for (index, title) in categoryTitles.enumerated() {
            let categoryButton = UIButton(type: .system)
            categoryButton.setTitle(title, for: .normal)
            categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            categoryButton.layer.cornerRadius = 15
            categoryButton.layer.borderWidth = 1
            categoryButton.layer.borderColor = UIColor.systemGray4.cgColor
            categoryButton.setTitleColor(.black, for: .normal)
            categoryButton.backgroundColor = .white
            categoryButton.tag = index
            categoryButton.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            contentView.addSubview(categoryButton)
            categoryButtons.append(categoryButton)
            // Create horizontal collection view
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.tag = index
            collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
            contentView.addSubview(collectionView)
            collectionViews.append(collectionView)
            categoryButton.snp.makeConstraints { make in
                make.top.equalTo(lastViewBottom).offset(20)
                make.centerX.equalToSuperview()
                make.width.equalTo(120)
                make.height.equalTo(35)
            }
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(categoryButton.snp.bottom).offset(10)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(180)
            }
            lastViewBottom = collectionView.snp.bottom
            // Fetch movie data per endpoint
            let endpoint = Endpoint.allCases[index]
            fetchMovieData(from: endpoint) { [weak self] movies in
                guard let self = self, let movies = movies else { return }
                self.movieLists[index] = movies
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
        }
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(lastViewBottom).offset(20)
        }
    }
    // MARK: - 버튼 탭 동작
    @objc func showMovieList() {
        updateSelectedButton(movieListButton)
        searchingView.endEditing(true)
        searchingView.hideSearchResults()
        searchingView.hideSearchTextField()
        setupMovieListView()
    }
    @objc func showSearch() {
        updateSelectedButton(searchButton)
        clearMovieListView()
        searchingView.showSearchTextField()
    }
    @objc func showProfile() {
        profileView.setupView()
        updateSelectedButton(profileButton)
        clearMovieListView()
        searchingView.endEditing(true)
        searchingView.hideSearchResults()
        searchingView.hideSearchTextField()
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    func clearMovieListView() {
        scrollView.removeFromSuperview()
        bannerImageView.removeFromSuperview()
        categoryButtons.removeAll()
        collectionViews.removeAll()
        contentView.subviews.forEach { $0.removeFromSuperview() }
        profileView.removeFromSuperview()
    }
    func updateSelectedButton(_ selected: UIButton) {
        let buttons = [movieListButton, searchButton, profileButton]
        let underlines = [movieListUnderline, searchUnderline, profileUnderline]
        for (button, underline) in zip(buttons, underlines) {
            let isSelected = (button == selected)
            underline.isHidden = !isSelected
            button.setTitleColor(.black, for: .normal)
        }
    }
    @objc func categoryButtonTapped(_ sender: UIButton) {
        guard let index = categoryButtons.firstIndex(of: sender) else { return }
        for (i, button) in categoryButtons.enumerated() {
            let isSelected = (i == index)
            button.backgroundColor = isSelected ? UIColor.systemBlue.withAlphaComponent(0.2) : .white
            button.layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : UIColor.systemGray4.cgColor
            button.setTitleColor(isSelected ? .systemBlue : .black, for: .normal)
        }
    }
}
// MARK: - URL session
struct MovieDataResponse: Codable {
    let results: [MovieData]
}
struct MovieData: Codable {
    let poster_path: String?
    let title: String?
    let overview: String?
    let vote_average: Double?
    let release_date: String?
}

enum Endpoint: String, CaseIterable {
    case nowPlaying = "now_playing"
    case popular = "popular"
    case topRated = "top_rated"
    case upcoming = "upcoming"
}
struct APIEndpoint {
    let baseURL = "https://api.themoviedb.org/3/movie/"
    let apiKey = "bbbd0e19cbdae7622268c7375e59a38e"
    func url(for endpoint: Endpoint) -> URL? {
        var components = URLComponents(string: baseURL + endpoint.rawValue)
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "ko-KR"),
            URLQueryItem(name: "page", value: "1")
        ]
        return components?.url
    }
}
let api = APIEndpoint()
func fetchMovieData(from endpoint: Endpoint, completion: @escaping ([MovieData]?) -> Void) {
    guard let url = api.url(for: endpoint) else {
        completion(nil)
        return
    }
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        do {
            let decodedResponse = try JSONDecoder().decode(MovieDataResponse.self, from: data)
            completion(decodedResponse.results)
        } catch {
            completion(nil)
        }
    }.resume()
}
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let index = collectionView.tag
        return movieLists[safe: index]?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let index = collectionView.tag
        if let movie = movieLists[safe: index]?[indexPath.item] {
            cell.configure(with: movie)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 170)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = collectionView.tag
        guard let movie = movieLists[safe: index]?[indexPath.item] else { return }
        
        let infoVC = InfoPageViewController()
        infoVC.movieData = movie
        navigationController?.pushViewController(infoVC, animated: true)
    }
}
class MovieCell: UICollectionViewCell {
    static let identifier = "MovieCell"
    private let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with movie: MovieData) {
        if let path = movie.poster_path {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            if let url = imageURL, let data = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: data)
            }
        }
    }
}
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
