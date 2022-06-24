//
//  SelfSizedTableView.swift
//  Pokedex
//
//  Created by axavierc on 24/06/2022.
//

import UIKit

open class SelfSizedTableView: UITableView {
    
    override open var contentSize: CGSize {
        didSet { // basically the contentSize gets changed each time a cell is added
            // --> the intrinsicContentSize gets also changed leading to smooth size update
            if oldValue != contentSize {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height)
    }
}
