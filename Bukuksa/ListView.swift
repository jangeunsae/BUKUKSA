//
//  ListView.swift
//  Bukuksa
//
//  Created by 장은새 on 7/15/25.
//

import UIKit
import SnapKit

class ListViewController: UIViewController {

    let testButton: UIButton = {
        let testButton = UIButton()
        testButton.setTitle("testButton", for: .normal)
        testButton.setTitleColor(.white, for: .normal)
        testButton.addTarget(self, action: #selector(goToNextVC), for: .touchUpInside)
        return testButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        view.addSubview(testButton)
        testButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @objc private func buttonTapped() {
        print("tapped")
    }
    
    @IBAction func goToNextVC() {
            self.navigationController?.pushViewController(InfoPageViewController(), animated: true)
            
        }

}
