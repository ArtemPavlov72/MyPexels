//
//  RootViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 25.07.2022.
//

import UIKit

class RootViewController: UIViewController {
    
    //MARK: - Private Properties
    private var viewModel: RootViewModelDelegate!
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
        loginVC.viewModel = viewModel.loginViewModel()
        
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
        loginVC.viewModel = viewModel.loginViewModel()
        
        let logoutScreen = UINavigationController(rootViewController: loginVC)
        animateDismissTransition(to: logoutScreen)
    }
    
    func switchToMainScreen() {
        let mainViewController = TabBarStartViewController()
        mainViewController.viewModel = viewModel.tabBarStartViewModel()
        let mainScreen = UINavigationController(rootViewController:  mainViewController)
        animateFadeTransition(to: mainScreen)
    }
    
    //MARK: - Private Methods
    private func loadRootController() {
        addChild(currentRootVC)
        currentRootVC.view.frame = view.bounds
        view.addSubview(currentRootVC.view)
        currentRootVC.didMove(toParent: self)
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        currentRootVC.willMove(toParent: nil)
        addChild(new)
        
        transition(
            from: currentRootVC,
            to: new,
            duration: 0.3,
            options: [.transitionCrossDissolve, .curveEaseOut],
            animations: {
            }) { [weak self] completed  in
                self?.currentRootVC.removeFromParent()
                new.didMove(toParent: self)
                self?.currentRootVC = new
                completion?()
            }
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        let initialFrame = CGRect(
            x: -view.bounds.width,
            y: 0,
            width: view.bounds.width,
            height: view.bounds.height
        )
        
        currentRootVC.willMove(toParent: nil)
        addChild(new)
        new.view.frame = initialFrame
        
        transition(
            from: currentRootVC,
            to: new,
            duration: 0.3,
            options: [],
            animations: {
                new.view.frame = self.view.bounds
            }) { [weak self] completed in
                self?.currentRootVC.removeFromParent()
                new.didMove(toParent: self)
                self?.currentRootVC = new
                completion?()
            }
    }
}
