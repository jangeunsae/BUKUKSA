//
//  RegisterView.swift
//  Bukuksa
//

//  Created by 송명균 on 7/16/25.
//

import UIKit
import SnapKit

class RegisterView: UIView {

    let logoImageView = UIImageView()
    let titleLabel = UILabel()

    let formView = UIView()
    let nameTextField = UITextField()
    let idTextField = UITextField()
    let passwordTextField = UITextField()
    let registerButton = UIButton(type: .system)

    var closeAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // 상단 로고
        logoImageView.image = UIImage(named: "icon")
        logoImageView.contentMode = .scaleAspectFit
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(50)
        }

        titleLabel.text = "BUKUKSA"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.systemGray
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(8)
            make.centerY.equalTo(logoImageView)
        }

        // Form View
        formView.layer.borderWidth = 1
        formView.layer.borderColor = UIColor.lightGray.cgColor
        formView.layer.cornerRadius = 8
        addSubview(formView)

        formView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(40)
        }

        nameTextField.placeholder = "이름"
        nameTextField.borderStyle = .roundedRect

        idTextField.placeholder = "ID"
        idTextField.borderStyle = .roundedRect

        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect

        formView.addSubview(nameTextField)
        formView.addSubview(idTextField)
        formView.addSubview(passwordTextField)

        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        idTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.leading.trailing.equalTo(nameTextField)
            make.height.equalTo(44)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(12)
            make.leading.trailing.equalTo(idTextField)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }

        // 등록 버튼
        registerButton.setTitle("등록", for: .normal)
        registerButton.backgroundColor = UIColor(red: 82/255, green: 99/255, blue: 123/255, alpha: 1)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 25
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        addSubview(registerButton)

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(formView.snp.bottom).offset(30)
            make.leading.trailing.equalTo(formView)
            make.height.equalTo(50)
        }
    }

    @objc private func registerTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let id = idTextField.text, !id.isEmpty,
              let pw = passwordTextField.text, !pw.isEmpty else {
            showAlert(title: "오류", message: "모든 항목을 입력해주세요.")
            return
        }

        UserDefaults.standard.set(id, forKey: "userID")
        UserDefaults.standard.set(pw, forKey: "userPassword")
        UserDefaults.standard.set(name, forKey: "userName")

        showAlert(title: "성공", message: "회원가입이 완료되었습니다.") {
            self.closeAction?()
        }
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        guard let vc = self.findViewController() else { return }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "확인", style: .default) { _ in
            completion?()
        })
        vc.present(alert, animated: true)
    }

    // UIView에서 부모 VC 찾기
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}

