//
//  Section2Cell.swift
//  Pokedex
//
//  Created by axavierc on 14/07/2022.
//

import UIKit

class Section2Cell: UITableViewCell {
    
    @IBOutlet weak var status1: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 0))
    }

    func initView() {
        status1.text = "detail_details".localized
    }

}

