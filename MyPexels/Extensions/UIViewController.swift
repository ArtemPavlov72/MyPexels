//
//  UIViewController.swift
//  MyPexels
//
//  Created by Артем Павлов on 21.04.2023.
//

import UIKit

extension UIViewController {
    func setupSubViews(_ subViews: UIView...) {
        subViews.forEach { view.addSubview($0) }
    }
}
