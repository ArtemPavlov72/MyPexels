//
//  AppDelegate.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = RootViewController()
        switchRootViewController()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.shared.saveContext()
    }
    
    //MARK: - Switch ViewControllers Methods
    private func switchRootViewController() {
        if !UserDefaults.standard.bool(forKey: "done") {
            AppDelegate.shared.rootViewController.showLoginScreen()
        } else {
            AppDelegate.shared.rootViewController.switchToMainScreen()
        }
    }
}

//MARK: - AppDelegate User Flow 
extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: RootViewController {
        return window?.rootViewController as! RootViewController
    }
}



