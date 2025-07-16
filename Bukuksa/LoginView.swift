//
//  LoginView.swift
//  Bukuksa
//
//  Created by 장은새 on 7/15/25.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    let logoImageView = UIImageView()
    let titleLabel = UILabel()

    let formView = UIView()
    let idTextField = UITextField()
    let passwordTextField = UITextField()

    let loginButton = UIButton(type: .system)
    let registerButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        logoImageView.image = UIImage(named: "icon")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(112)
        }

        

        formView.layer.borderWidth = 1
        formView.layer.borderColor = UIColor.lightGray.cgColor
        formView.layer.cornerRadius = 8
        view.addSubview(formView)

        formView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(40)
        }

        idTextField.placeholder = "ID"
        idTextField.borderStyle = .roundedRect

        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect

        formView.addSubview(idTextField)
        formView.addSubview(passwordTextField)

        idTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(12)
            make.leading.trailing.equalTo(idTextField)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }

        loginButton.setTitle("로그인", for: .normal)
        loginButton.backgroundColor = UIColor(red: 82/255, green: 99/255, blue: 123/255, alpha: 1)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 25
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        view.addSubview(loginButton)

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(formView.snp.bottom).offset(30)
            make.leading.trailing.equalTo(formView)
            make.height.equalTo(50)
        }

        registerButton.setTitle("회원가입", for: .normal)
        registerButton.setTitleColor(UIColor(red: 82/255, green: 99/255, blue: 123/255, alpha: 1), for: .normal)
        registerButton.layer.cornerRadius = 25
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor(red: 82/255, green: 99/255, blue: 123/255, alpha: 1).cgColor
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        view.addSubview(registerButton)

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(12)
            make.leading.trailing.equalTo(loginButton)
            make.height.equalTo(50)
        }
    }

    @objc func loginTapped() {
        guard let id = idTextField.text,
              let pw = passwordTextField.text else { return }

        let savedID = UserDefaults.standard.string(forKey: "userID")
        let savedPW = UserDefaults.standard.string(forKey: "userPassword")

        if id == savedID && pw == savedPW {
            showAlert(title: "성공", message: "로그인 성공!")
        } else {
            showAlert(title: "실패", message: "아이디 또는 비밀번호가 틀렸습니다.")
        }
    }

    @objc func registerTapped() {
        let registerVC = UIViewController()
        let registerView = RegisterView()
        registerView.closeAction = {
            registerVC.dismiss(animated: true)
        }

        registerVC.view = registerView
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
