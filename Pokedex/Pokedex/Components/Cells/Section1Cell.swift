//
//  Section1Cell.swift
//  Pokedex
//
//  Created by axavierc on 14/07/2022.
//

import UIKit

class Section1Cell: UITableViewCell {
    
    @IBOutlet weak var status1: UILabel!
    @IBOutlet weak var status2: UILabel!
    @IBOutlet weak var status3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 0))
    }
    
    func initView() {
        status1.text = "detail_stats".localized
        status2.text = "detail_base".localized
        status3.text = "detail_effort".localized
    }

}
