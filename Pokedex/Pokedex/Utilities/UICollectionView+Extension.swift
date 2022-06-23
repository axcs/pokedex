//
//  UICollectionView+Extension.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

import Foundation
import UIKit

/**
 This UICollectionView extension depends from: NSObject+Extension.swift and NSString+Extension.swift files to work properly
 
 For register and dequeue work properly xib and class must have the same name.
 
 Usage:
 register: collectionView.register(cellType: <Name of class>.self)
 dequeue: collectionView.dequeueReusableCell()
 */
extension UICollectionView {
    
    public func register<T: UICollectionViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.nameOfClass
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    public func register<T: UICollectionViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type,
                                                             for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.nameOfClass, for: indexPath) as? T else {
            "Could not dequeue cell with type: \(type). Returning empty cell".errorLog()
            return T()
        }
        return cell
    }
    
    public func registerHeaderNib<T:UICollectionReusableView>(_ header: T.Type, bundle: Bundle? = nil) {
        registerReusableViewNib(header, bundle: bundle, kind: UICollectionView.elementKindSectionHeader)
    }
    
    public func registerFooterNib<T:UICollectionReusableView>(_ footer: T.Type, bundle: Bundle? = nil) {
        registerReusableViewNib(footer, bundle: bundle, kind: UICollectionView.elementKindSectionFooter)
    }
    
    public func dequeueHeader<T:UICollectionReusableView>(_ header: T.Type, forIndexPath indexPath: IndexPath) -> T {
        
       return dequeueReusableView(header, kind: UICollectionView.elementKindSectionHeader, forIndexPath: indexPath)
    }
    
    public func dequeueFooter<T:UICollectionReusableView>(_ footer: T.Type, forIndexPath indexPath: IndexPath) -> T {
        
        return dequeueReusableView(footer, kind: UICollectionView.elementKindSectionFooter, forIndexPath: indexPath)
    }
    

    private func dequeueReusableView<T:UICollectionReusableView>(_ view: T.Type, kind: String, forIndexPath indexPath: IndexPath) -> T {
        
        guard let reusableView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: view.nameOfClass, for: indexPath) as? T else {
            "Could not dequeue reusableView of type: \(view). Returning empty reusableView".errorLog()
            return T()
        }
        return reusableView
    }
    
    private func registerReusableViewNib<T:UICollectionReusableView>(_ view: T.Type, bundle: Bundle? = nil, kind: String) {
        
        let className = view.nameOfClass
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }
}

