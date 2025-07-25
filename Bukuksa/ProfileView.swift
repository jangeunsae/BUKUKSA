//
//  ProfileView.swift
//  Bukuksa
//
//  Created by 장은새 on 7/15/25.
//

import Foundation
import UIKit
import CoreData
import SnapKit

class ProfileView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let greetingLabel = UILabel()
    private let reservationLabel = UILabel()
    private let qrCodeLabel = UILabel()
    private let qrCodeImageView = UIImageView()
    private let reservecontainer = UIView()
    private let qrcontainer = UIView()
    private let profileTableView = UITableView()
    
    var userdataArray: [[String: Any]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        
        let reservations = UserDefaults.standard.array(forKey: "reservations") as? [[String: Any]] ?? []
        userdataArray = reservations
        
        addSubview(profileTableView)
        
        profileTableView.register(ReservationCell.self, forCellReuseIdentifier: "ReservationCell")
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        profileTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
        
        headerView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .systemGray5
        
        headerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
        }
        nameLabel.font = .systemFont(ofSize: 30, weight: .bold)
        nameLabel.textColor = .label
        let userName = UserDefaults.standard.string(forKey: "userName") ?? "사용자명"
        nameLabel.text = userName
        
        headerView.addSubview(greetingLabel)
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
            make.leading.equalTo(profileImageView.snp.leading)
        }
        greetingLabel.font = .systemFont(ofSize: 15, weight: .bold)
        greetingLabel.textColor = .lightGray
        greetingLabel.text = "부산 국제 영화제를 찾아주셔서 감사합니다."
        
        headerView.addSubview(reservationLabel)
        reservationLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        reservationLabel.backgroundColor = .systemBlue
        reservationLabel.layer.cornerRadius = 12
        reservationLabel.clipsToBounds = true
        reservationLabel.textColor = .white
        reservationLabel.font = .systemFont(ofSize: 20, weight: .bold)
        reservationLabel.text = "예매내역"
        reservationLabel.textAlignment = .center
        
        profileTableView.tableHeaderView = headerView
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
        
        footerView.addSubview(qrcontainer)
        qrcontainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        qrcontainer.backgroundColor = .systemGray
        qrcontainer.layer.cornerRadius = 12
        qrcontainer.clipsToBounds = true
        
        qrcontainer.addSubview(qrCodeLabel)
        qrCodeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            
        }
        qrCodeLabel.textColor = .white
        qrCodeLabel.font = .systemFont(ofSize: 20, weight: .bold)
        qrCodeLabel.text = "QR CODE"
        
        footerView.addSubview(qrCodeImageView)
        qrCodeImageView.contentMode = .scaleAspectFit
        qrCodeImageView.image = UIImage(named: "QRCode")
        qrCodeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(qrcontainer.snp.bottom).offset(10)
            make.width.equalTo(330)
            make.height.equalTo(330)
        }
        profileTableView.tableFooterView = footerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userdataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else {
            return UITableViewCell()
        }
        let reservation = userdataArray[indexPath.row]
        if let title = reservation["movieTitle"] as? String,
           let date = reservation["date"] as? String,
           let count = reservation["peopleCount"] as? Int,
           let price = reservation["totalPrice"] as? Int {
            cell.movieTitleLabel.text = title
            cell.dateLabel.text = date
            cell.peopleCountLabel.text = "\(count)"
            cell.totalPriceLabel.text = "\(price)"
        }
        return cell
    }
    //    영화이미지, 영화명, 날짜, 인원수, 총 가격
    class ReservationCell: UITableViewCell {
        let movieTitleLabel = UILabel()
        let dateLabel = UILabel()
        let peopleCountLabel = UILabel()
        let totalPriceLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            configureView()
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func configureView() {
            [movieTitleLabel, dateLabel, peopleCountLabel, totalPriceLabel].forEach {
                contentView.addSubview($0)
                $0.font = .systemFont(ofSize: 16)
                $0.textColor = .black
                $0.numberOfLines = 1
            }
            
            movieTitleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(12)
                make.leading.trailing.equalToSuperview().inset(16)
            }
            
            dateLabel.snp.makeConstraints { make in
                make.top.equalTo(movieTitleLabel.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(16)
            }
            
            peopleCountLabel.snp.makeConstraints { make in
                make.top.equalTo(dateLabel.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(16)
            }
            
            totalPriceLabel.snp.makeConstraints { make in
                make.top.equalTo(peopleCountLabel.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(12)
            }
        }
    }
}
