//
//  BookingView.swift
//  Bukuksa
//
//  Created by 장은새 on 7/15/25.
//

import SnapKit
import UIKit
import Alamofire

struct Movie: Codable {
    let id: Int
    let title: String
    let imageUrl: String
    let description: String
}

class BookingViewController: UIViewController {
    
    var movie: Movie!
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "결제하기"
        return title
    }()
    
    let infoLabel: UILabel = {
        let info = UILabel()
        info.text = "예매정보"
        return info
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    let imageTitleLabel: UILabel = {
        let title = UILabel()
        title.text = "좀비딸"
        return title
    }()
    
    let dateLabel: UILabel = {
        let date = UILabel()
        date.text = "2025-07-15 14:00"
        return date
    }()
    
    let peopleCountLabel: UILabel = {
        let peopleCount = UILabel()
        peopleCount.text = "성인 1"
        return peopleCount
    }()
    
    let totalPriceLabel: UILabel = {
        let totalPrice = UILabel()
        totalPrice.text = "100,000원"
        return totalPrice
    }()
    
    let paymentButton: UIButton = {
        let payment = UIButton()
        payment.setTitle("결제하기", for: .normal)
        return payment
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "예매하기"

        // Title label
        let titleLabel = UILabel()
        titleLabel.text = "예매정보"
        titleLabel.font = .boldSystemFont(ofSize: 24)

        // 영화명 row
        let movieRow = makeRow(title: "영화명", value: movie?.title ?? "영화명")

        // 날짜 row
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let now = dateFormatter.string(from: Date())
        let dateRow = makeRow(title: "날짜", value: now)

        // 인원수 row (카운터)
        let countTitle = UILabel()
        countTitle.text = "인원"

        let countValueLabel = UILabel()
        countValueLabel.text = "1"
        countValueLabel.textAlignment = .center
        countValueLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true

        let minusButton = UIButton()
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.black, for: .normal)
        let plusButton = UIButton()
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.black, for: .normal)

        let counterStack = UIStackView(arrangedSubviews: [countValueLabel, minusButton, plusButton])
        counterStack.axis = .horizontal
        counterStack.spacing = 10

        let peopleStack = UIStackView(arrangedSubviews: [countTitle, counterStack])
        peopleStack.axis = .horizontal
        peopleStack.distribution = .equalSpacing

        // 총 가격 row
        let totalTitleLabel = UILabel()
        totalTitleLabel.text = "총 가격"

        let totalPriceLabel = UILabel()
        totalPriceLabel.textAlignment = .right
        totalPriceLabel.font = .boldSystemFont(ofSize: 18)

        let totalStack = UIStackView(arrangedSubviews: [totalTitleLabel, totalPriceLabel])
        totalStack.axis = .horizontal
        totalStack.distribution = .equalSpacing

        // 결제 버튼
        let payButton = UIButton()
        payButton.setTitle("결제하기", for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.backgroundColor = .systemBlue
        payButton.layer.cornerRadius = 8

        // 메인 스택
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, movieRow, dateRow, peopleStack, totalStack])
        mainStack.axis = .vertical
        mainStack.spacing = 20

        view.addSubview(mainStack)
        view.addSubview(payButton)

        mainStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        payButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }

        // 인원수 및 가격 로직
        var count = 1
        func updatePrice() {
            let price = 10000
            countValueLabel.text = "\(count)"
            totalPriceLabel.text = "\(count * price)원"
        }
        minusButton.addAction(UIAction { _ in
            if count > 1 {
                count -= 1
                updatePrice()
            }
        }, for: .touchUpInside)
        plusButton.addAction(UIAction { _ in
            count += 1
            updatePrice()
        }, for: .touchUpInside)
        updatePrice()
    }
    
    // 결제 버튼 동작 등은 필요시 여기에 구현
    
    //코어 데이터에 저장
    @objc func saveToCoreData() {
        
    }

    private func makeRow(title: String, value: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16)
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 16)
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }
    
}
