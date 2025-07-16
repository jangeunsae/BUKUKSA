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
        return reservation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        view.addSubview(titleLabel)
        view.addSubview(ratingLabel)
        view.addSubview(reservationButton)
        view.addSubview(imageView)
        
        //탭 아이템 제목
        navigationItem.title = "부국사"
        
        //제목
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
        }
        
        //이미지 뷰 틀
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(titleLabel.snp.bottom).offset(40)
            make.size.equalTo(80)
        }
        
        //평점
        ratingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(imageView.snp.bottom).offset(60)
        }
        
        //예매 버튼
        reservationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(40)
        }
        
    }
    
    @objc private func buttonTapped() {
        self.navigationController?.pushViewController(BookingViewController(), animated: true)
    }


}
