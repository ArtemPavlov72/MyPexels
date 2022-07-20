//
//  CollectionView.swift
//  MyPexels
//
//  Created by Artem Pavlov on 20.07.2022.
//

import UIKit

extension UICollectionViewController {
    @objc(collectionView:layout:insetForSectionAtIndex:)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    @objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}
