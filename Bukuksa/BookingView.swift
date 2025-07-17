//
//  BookingView.swift
//  Bukuksa
//
//  Created by 장은새 on 7/15/25.
//

import SnapKit
import UIKit
import Alamofire

class BookingViewController: UIViewController {
    
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
        payment.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
        return payment
    }()
    
    let likeButton: UIButton = {
        let like = UIButton()
        like.setTitle("like", for: .normal)
        like.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return like
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(titleLabel)
        view.addSubview(infoLabel)
        view.addSubview(imageView)
        view.addSubview(imageTitleLabel)
        view.addSubview(dateLabel)
        view.addSubview(peopleCountLabel)
        view.addSubview(totalPriceLabel)
        view.addSubview(paymentButton)
        view.addSubview(likeButton)
        buttonActions()
        
        //탭 아이템 제목
        navigationItem.title = "부국사"
        
        //제목
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.25)
        }
        
        //정보 라벨
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        //이미지 뷰
        imageView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(140)
        }
        
        //이미지 제목 라벨
        imageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        //날짜 라벨
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(imageTitleLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        //인원수 라벨
        peopleCountLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalTo(imageTitleLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleCountLabel.snp.bottom).offset(10)
            make.leading.equalTo(imageTitleLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        paymentButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.leading.equalTo(paymentButton.snp.trailing).offset(20)
        }
        
    }
    
    @objc private func paymentButtonTapped() {
//        self.navigationController?.pushViewController(ListViewController(), animated: true)
        let sheet = UIAlertController(title: "카메라", message: "카메라를 키겠습니까?", preferredStyle: .actionSheet)

        sheet.addAction(UIAlertAction(title: "Yes!", style: .destructive, handler: { _ in print("yes 클릭") }))

        sheet.addAction(UIAlertAction(title: "No!", style: .cancel, handler: { _ in print("yes 클릭") }))

        present(sheet, animated: true)
    }
    
    private func buttonActions() {
            likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        }
    
    
    // 버튼 클릭 애니메이션
        private func animateButtonPress(_ button: UIButton) {
            UIView.animate(withDuration: 0.1,
                           animations: {
                // 눌렸을 때 크기가 작아짐
                button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                           completion: { _ in
                // 애니메이션 완료 후 원래 크기로 돌아옴
                UIView.animate(withDuration: 0.1) {
                    button.transform = CGAffineTransform.identity
                }
            })
        }
    
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
            animateButtonPress(sender)
            
            // 버튼 색상 변경
            if sender.titleColor(for: .normal) == .lightGray {
                sender.setTitleColor(.systemRed, for: .normal)
                sender.layer.borderColor = UIColor.red.cgColor
            } else {
                sender.setTitleColor(.lightGray, for: .normal)
                sender.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    
}
