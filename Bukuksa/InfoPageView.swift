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
    
    let ratingLabel: UILabel = {
        let rating = UILabel()
        rating.text = "rating 10.0"
        return rating
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        view.addSubview(titleLabel)
        view.addSubview(ratingLabel)
        
        //탭 아이템 제목
        navigationItem.title = "부국사"
        
        //제목
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
        }
        
        //평점
        ratingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(titleLabel.snp.bottom).offset(150)
        }
        
    }


}
