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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(titleLabel)
        view.addSubview(infoLabel)
        view.addSubview(imageView)
        view.addSubview(imageTitleLabel)
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
            make.size.equalTo(140)
        }
        
        //이미지 제목 라벨
        imageTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(20)
            make.top.equalTo(imageView).offset(20)
        }
    }
}
