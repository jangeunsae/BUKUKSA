import UIKit
import SnapKit

struct MovieResponse: Decodable {
    let results: [MovieInfo]
}

struct MovieInfo: Decodable {
    let title: String
    let overview: String
    let vote_average: Double
    let poster_path: String?
    let release_date: String?
}

class InfoPageViewController: UIViewController {

    private var selectedMovieTitle: String?

    let titleLabel: UILabel = {
        let title = UILabel()
        title.text = ""
        title.textColor = .systemPurple
        title.font = .boldSystemFont(ofSize: 24)
        return title
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "스크립트가 여기에 들어갑니다."
        return label
    }()

    let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "평점: -"
        return label
    }()

    let releaseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "출시일: -"
        return label
    }()

    let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .leading
        return stack
    }()

    let reservationButton: UIButton = {
        let reservation = UIButton()
        reservation.setTitle("예매하기", for: .normal)
        reservation.setTitleColor(.white, for: .normal)
        reservation.backgroundColor = .systemBlue
        reservation.layer.cornerRadius = 25
        reservation.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        reservation.titleLabel?.font = .boldSystemFont(ofSize: 18)
        reservation.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return reservation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        [imageView, titleLabel, descriptionLabel, reservationButton, infoStackView].forEach {
            view.addSubview($0)
        }
        infoStackView.addArrangedSubview(ratingLabel)
        infoStackView.addArrangedSubview(releaseLabel)

        navigationItem.title = ""

        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(300)
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        infoStackView.snp.makeConstraints { make in
            make.bottom.equalTo(reservationButton.snp.top).offset(-20)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        reservationButton.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        fetchMovieData()
    }

    @objc private func buttonTapped() {
        let bookingVC = BookingViewController()
        bookingVC.movieTitle = self.selectedMovieTitle
        self.navigationController?.pushViewController(bookingVC, animated: true)
    }

    private func fetchMovieData() {
        let apiKey = "bbbd0e19cbdae7622268c7375e59a38e"
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=ko-KR"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(MovieResponse.self, from: data)
                if let movie = result.results.first {
                    DispatchQueue.main.async {
                        self.titleLabel.text = movie.title
                        self.navigationItem.title = movie.title
                        self.selectedMovieTitle = movie.title
                        let rating = String(format: "%.1f", movie.vote_average)
                        let releaseDate = movie.release_date ?? "-"
                        self.ratingLabel.text = "평점: \(rating)/10"
                        self.releaseLabel.text = "출시일: \(releaseDate)"
                        self.descriptionLabel.text = movie.overview

                        if let posterPath = movie.poster_path {
                            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                            if let imageUrl = imageUrl {
                                URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                                    guard let data = data, let image = UIImage(data: data) else { return }
                                    DispatchQueue.main.async {
                                        self.imageView.image = image
                                    }
                                }.resume()
                            }
                        }
                    }
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
}
