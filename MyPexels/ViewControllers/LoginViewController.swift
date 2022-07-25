//
//  LoginViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.07.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var nameTextField: UITextField = {
        let name = UITextField()
        name.layer.cornerRadius = 15
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
    private func setupSubViews(_ subViews: UIView...) {
        subViews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupConstraints() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func enterButtonTapped() {
        guard let inputText = nameTextField.text, !inputText.isEmpty else {return}
        let tabBarStartVC = TabBarStartViewController()
        tabBarStartVC.navigationItem.hidesBackButton = true
        UserDefaults.standard.set(true, forKey: "done")
        show(tabBarStartVC, sender: nil)
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
