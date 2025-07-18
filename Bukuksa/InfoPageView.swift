//
//  InfoPageView.swift
//  Bukuksa
//
//  Created by 장은새 on 7/15/25.
//

import UIKit
import SnapKit
import Alamofire

class InfoPageViewController: UIViewController {

    let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "좀비딸"
        return title
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray
        return imageView
    }()

    let ratingLabel: UILabel = {
        let rating = UILabel()
        rating.text = "rating 10.0"
        return rating
    }()

    let reservationButton: UIButton = {
        let reservation = UIButton()
        reservation.setTitle("예매하기", for: .normal)
        reservation.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        reservation.setTitleColor(.white, for: .normal)
        reservation.backgroundColor = .systemBlue
        reservation.layer.cornerRadius = 8
        return reservation
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "스크립트가 여기에 들어갑니다."
        return label
    }()
    
    let likeButton: UIButton = {
        let like = UIButton()
        like.setTitle("like", for: .normal)
        return like
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        [imageView, titleLabel, ratingLabel, descriptionLabel, reservationButton].forEach {
            view.addSubview($0)
        }

        navigationItem.title = "좀비딸"

        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        reservationButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            make.height.equalTo(50)
        }

        fetchMovieData()
    }
    
    @objc private func buttonTapped() {
        let bookingVC = BookingViewController()
        self.navigationController?.pushViewController(bookingVC, animated: true)
    }

    private func fetchMovieData() {
        // 임시 URL 예시
        let imageUrlString = "https://example.com/zombiedaughter.jpg"
        let titleText = "좀비딸"
        let ratingText = "rating 10.0"
        let descriptionText = "이 영화는 좀비가 된 딸과 아빠의 이야기를 그린 감동 실화입니다. 길어질 수도 있으니 스크롤이 필요해요. 여러 줄 텍스트를 보여주는 예시입니다. 계속 이어지는 텍스트입니다."

        if let url = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }.resume()
        }

        titleLabel.text = titleText
        ratingLabel.text = ratingText
        descriptionLabel.text = descriptionText
    }
    

}
