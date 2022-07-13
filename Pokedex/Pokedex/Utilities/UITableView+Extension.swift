//
//  UITableView+Extension.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

import Foundation
import UIKit

/**
 This UITableView extension depends from: NSObject+Extension.swift and NSString+Extension.swift files to work properly
 
 For register and dequeue work properly xib and class must have the same name.
 
 Usage:
 register: tableView.register(cellType: <Name of class>.self)
 dequeue: tableView.dequeueReusableCell()
 */

extension UITableView {
    
    public func register<T: UITableViewCell>(_ cellType: T.Type, forCellReuseIdentifier identifier: String) {
        let className = cellType.nameOfClass
        let nib = UINib(nibName: className, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(with type: T.Type,
                                                             for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: type.nameOfClass, for: indexPath) as? T else {
            "Could not dequeue cell with type: \(type). Returning empty cell".errorLog()
            return T()
        }
        
       return cell
    }
}
