//
//  LoginViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.07.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Public Properties
    var viewModel: LoginViewModelProtocol!
    
    //MARK: - Private Properties
    private lazy var nameTextField: UITextField = {
        let name = UITextField()
        name.placeholder = "Enter your name"
        return name
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemGray2
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 10.0
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(enterButton)
        return stackView
    }()
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        nameTextField.delegate = self
        setupSubViews(verticalStackView)
        setupConstraints()
    }
    
    //MARK: - Private Methods    
    private func setupConstraints() {
        verticalStackView.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    @objc private func enterButtonTapped() {
        guard let inputText = nameTextField.text, !inputText.isEmpty else {return}
        let nameTrimmingText = inputText.trimmingCharacters(in: .whitespaces)
        
        viewModel.enterButtonPressed(with: nameTrimmingText)
                
        let tabBarStartVC = TabBarStartViewController()
        tabBarStartVC.viewModel = viewModel.tabBarStartViewModel()
        tabBarStartVC.navigationItem.hidesBackButton = true
        
        AppDelegate.shared.rootViewController.switchToMainScreen()
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterButtonTapped()
        return true
    }
}

