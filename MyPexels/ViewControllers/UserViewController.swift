//
//  ViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

class UserViewController: UIViewController {

    private var pexelsData: Pexels?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NetworkManager.shared.fetchData(from: "https://api.pexels.com/v1") { result in
            switch result {
            case .success(let pexelsData):
                self.pexelsData = pexelsData
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}

