//
//  ViewController.swift
//  Bukuksa
//
//  Created by 장은새 on 7/15/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let searchingView = SearchingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(searchingView)
        searchingView.snp.makeConstraints { make in            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

