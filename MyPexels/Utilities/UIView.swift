//
//  UIView.swift
//  MyPexels
//
//  Created by Artem Pavlov on 10.06.2022.
//

import UIKit

func showSpinner(in view: UIView) -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView(frame: view.bounds)
    activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    activityIndicator.startAnimating()
    activityIndicator.hidesWhenStopped = true
    view.addSubview(activityIndicator)
    return activityIndicator
}
