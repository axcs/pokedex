//
//  HeaderPokemonCell.swift
//  Pokedex
//
//  Created by axavierc on 28/06/2022.
//

import UIKit

class HeaderPokemonCell: UITableViewCell {
    
    @IBOutlet weak var imageViewPoke: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initComp()
    }
    
    func initComp(){
        imageViewPoke.layer.shadowColor = UIColor.black.cgColor
        imageViewPoke.layer.shadowOffset = CGSize(width: 6, height: 9)
        imageViewPoke.layer.shadowOpacity = 0.5
        imageViewPoke.layer.shadowRadius = 5.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    var descText: String? {
      didSet {
          descLabel.text = descText
      }
    }
    

}
