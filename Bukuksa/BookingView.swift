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
    
    var movieTitle: String?
    let dateRowLabel = UILabel()
    var count = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "결제하기"

        // Title label
        let titleLabel = UILabel()
        titleLabel.text = "예매하기"
        titleLabel.font = .boldSystemFont(ofSize: 30)

        // 영화명 row
        let movieTitleLabel = UILabel()
        movieTitleLabel.text = movieTitle ?? "영화명"
        movieTitleLabel.font = .boldSystemFont(ofSize: 20)
        let movieRow = makeRow(title: "영화명", valueLabel: movieTitleLabel)

        // 날짜 row
        dateRowLabel.font = .boldSystemFont(ofSize: 20)
        let dateRow = makeRow(title: "날짜", valueLabel: dateRowLabel)
        updateCurrentTime()
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateCurrentTime()
        }

        // 인원수 row (카운터)
        let countTitle = UILabel()
        countTitle.text = "인원"
        countTitle.font = .boldSystemFont(ofSize: 20)

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

        let counterStack = UIStackView(arrangedSubviews: [minusButton, countValueLabel, plusButton])
        counterStack.axis = .horizontal
        counterStack.spacing = 10
        counterStack.alignment = .center

        [minusButton, plusButton].forEach {
            $0.backgroundColor = .systemGray5
            $0.layer.cornerRadius = 10
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(30)
            }
        }

        let peopleStack = UIStackView(arrangedSubviews: [countTitle, counterStack])
        peopleStack.axis = .horizontal
        peopleStack.distribution = .equalSpacing

        // 총 가격 row
        let totalTitleLabel = UILabel()
        totalTitleLabel.text = "총 가격"
        totalTitleLabel.font = .boldSystemFont(ofSize: 20)

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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        movieRow.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        dateRow.snp.makeConstraints { make in
            make.top.equalTo(movieRow.snp.bottom).offset(80)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        peopleStack.snp.makeConstraints { make in
            make.top.equalTo(dateRow.snp.bottom).offset(80)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        totalStack.snp.makeConstraints { make in
            make.top.equalTo(peopleStack.snp.bottom).offset(80)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        payButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.greaterThanOrEqualTo(200)
        }

        // 인원수 및 가격 로직
        func updatePrice() {
            let price = 7000
            countValueLabel.text = "\(count)"
            totalPriceLabel.text = "\(count * price)원"
        }
        minusButton.addAction(UIAction { _ in
            if self.count > 1 {
                self.count -= 1
                updatePrice()
            }
        }, for: .touchUpInside)
        plusButton.addAction(UIAction { _ in
            self.count += 1
            updatePrice()
        }, for: .touchUpInside)
        updatePrice()

        // 결제하기 버튼에 알림 및 홈 이동 로직 추가
        payButton.addAction(UIAction { _ in
            let alert = UIAlertController(title: "결제 확인", message: "결제를 진행하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                let defaults = UserDefaults.standard
                defaults.set(self.movieTitle ?? "", forKey: "reservedMovieTitle")
                defaults.set(self.dateRowLabel.text ?? "", forKey: "reservedDate")
                defaults.set(self.count, forKey: "reservedPeopleCount")
                defaults.set(self.count * 7000, forKey: "reservedTotalPrice")
                
//                let homeVC = ListViewController() <- 목록 화면 넣으면 됨.
//                self.navigationController?.setViewControllers([homeVC], animated: true)
            }))
            self.present(alert, animated: true)
        }, for: .touchUpInside)
        
        
        //잘 저장됐나 확인 프린트.
        let defaults = UserDefaults.standard

        if let movieTitle = defaults.string(forKey: "reservedMovieTitle"),
           let date = defaults.string(forKey: "reservedDate") {
            let peopleCount = defaults.integer(forKey: "reservedPeopleCount")
            let totalPrice = defaults.integer(forKey: "reservedTotalPrice")
            
            print("✅ 예매 정보:")
            print("🎬 영화명: \(movieTitle)")
            print("📅 날짜: \(date)")
            print("👥 인원 수: \(peopleCount)")
            print("💰 총 가격: \(totalPrice)원")
        } else {
            print("⚠️ 저장된 예매 정보가 없습니다.")
        }
        
    }
    
    //코어 데이터에 저장
    @objc func saveToCoreData() {
        
    }
    
    private func updateCurrentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        dateRowLabel.text = formatter.string(from: Date())
    }

    private func makeRow(title: String, value: String) -> UIStackView {
        let label = UILabel()
        label.text = value
        label.font = .boldSystemFont(ofSize: 18)
        return makeRow(title: title, valueLabel: label)
    }

    private func makeRow(title: String, valueLabel: UILabel) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 18)
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }
    

}
