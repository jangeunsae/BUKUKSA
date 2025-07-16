//
//  MovieCell.swift
//  Bukuksa
//
//  Created by 김재만 on 7/16/25.
//

import UIKit
import SnapKit

class MovieCell: UICollectionViewCell {
    
    static let identifier = "MovieCell"
    
    private let posterImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink // 임시 포스터 대체 색상
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.clipsToBounds = true
    }
    
    func configure(index: Int) {
        // 실제 영화 포스터 이미지를 넣는 부분
        // 지금은 더미 색상으로 대체 중
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
