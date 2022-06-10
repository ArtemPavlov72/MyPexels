//
//  UIView.swift
//  MyPexels
//
//  Created by Artem Pavlov on 10.06.2022.
//

import UIKit

extension UIImage {
    var cropRatio: CGFloat {
        return CGFloat(size.width / size.height)
    }
    
    func height(width: CGFloat) -> CGFloat {
        return width / self.cropRatio
    }
    
    func width(height: CGFloat) -> CGFloat {
        return height * self.cropRatio
    }
}
