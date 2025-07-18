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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "결제하기"

        // Title label
        let titleLabel = UILabel()
        titleLabel.text = "예매정보"
        titleLabel.font = .boldSystemFont(ofSize: 26)

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
        countTitle.font = .boldSystemFont(ofSize: 18)

        let countValueLabel = UILabel()
        countValueLabel.text = "1"
        countValueLabel.textAlignment = .center
        countValueLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        countValueLabel.font = .boldSystemFont(ofSize: 18)

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
        totalTitleLabel.font = .boldSystemFont(ofSize: 18)

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
        payButton.layer.cornerRadius = 25
        payButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        payButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)

        view.addSubview(titleLabel)
        view.addSubview(movieRow)
        view.addSubview(dateRow)
        view.addSubview(peopleStack)
        view.addSubview(totalStack)
        view.addSubview(payButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        movieRow.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        dateRow.snp.makeConstraints { make in
            make.top.equalTo(movieRow.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        peopleStack.snp.makeConstraints { make in
            make.top.equalTo(dateRow.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        totalStack.snp.makeConstraints { make in
            make.top.equalTo(peopleStack.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        payButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.greaterThanOrEqualTo(200)
        }

        // 인원수 및 가격 로직
        var count = 1
        func updatePrice() {
            let price = 17000
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

        // 결제하기 버튼에 알림 및 홈 이동 로직 추가
        payButton.addAction(UIAction { _ in
            let alert = UIAlertController(title: "결제 확인", message: "결제를 진행하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
//                let homeVC = ListViewController() <- 목록 화면 넣으면 됨.
//                self.navigationController?.setViewControllers([homeVC], animated: true)
            }))
            self.present(alert, animated: true)
        }, for: .touchUpInside)
    }
    
    //코어 데이터에 저장
    @objc func saveToCoreData() {
        
    }

    private func makeRow(title: String, value: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 18)
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .boldSystemFont(ofSize: 18)
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }
    
}
