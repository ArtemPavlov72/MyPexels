//
//  RootViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 25.07.2022.
//

import UIKit

class RootViewController: UIViewController {
    
    //MARK: - Private Properties
    private var viewModel: RootViewModelDelegate?
    private var currentRootVC: UIViewController
    
    //MARK: - Init
    init() {
        currentRootVC = LoginViewController()
        super.init(nibName:  nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RootViewModel()
        loadRootController()
    }
    
    //MARK: - Public Methods
    func showLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.viewModel = viewModel?.loginViewModel()
        
        let newVC = UINavigationController(rootViewController: loginVC)
        addChild(newVC)
        newVC.view.frame = view.bounds
        view.addSubview(newVC.view)
        newVC.didMove(toParent: self)
        currentRootVC.willMove(toParent: nil)
        currentRootVC.view.removeFromSuperview()
        currentRootVC.removeFromParent()
        currentRootVC = newVC
    }
    
    func switchToLogout() {
        let loginVC = LoginViewController()
        loginVC.viewModel = viewModel?.loginViewModel()
        
        let logoutScreen = UINavigationController(rootViewController: loginVC)
        animateTransition(to: logoutScreen, isLogout: true)
    }
    
    func switchToMainScreen() {
        let mainViewController = TabBarStartViewController()
        mainViewController.viewModel = viewModel?.tabBarStartViewModel()
        let mainScreen = UINavigationController(rootViewController:  mainViewController)
        animateTransition(to: mainScreen, isLogout: false)
    }
    
    //MARK: - Private Methods
    private func loadRootController() {
        addChild(currentRootVC)
        currentRootVC.view.frame = view.bounds
        view.addSubview(currentRootVC.view)
        currentRootVC.didMove(toParent: self)
    }
    
    private func animateTransition(to newVC: UIViewController, isLogout: Bool, completion: (() -> Void)? = nil) {
        if isLogout {
            let initialFrame = CGRect(
                x: -view.bounds.width,
                y: 0,
                width: view.bounds.width,
                height: view.bounds.height
            )
            newVC.view.frame = initialFrame
        }
        
        currentRootVC.willMove(toParent: nil)
        addChild(newVC)
        
        transition(
            from: currentRootVC,
            to: newVC,
            duration: 0.3,
            options: isLogout ? [] : [.transitionCrossDissolve, .curveEaseOut],
            animations: {
                newVC.view.frame = self.view.bounds
            }
        ) { [weak self] completed in
            self?.currentRootVC.removeFromParent()
            newVC.didMove(toParent: self)
            self?.currentRootVC = newVC
            completion?()
        }
    }
}
