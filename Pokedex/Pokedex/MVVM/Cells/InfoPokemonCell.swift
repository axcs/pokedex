//
//  InfoPokemonCell.swift
//  Pokedex
//
//  Created by axavierc on 28/06/2022.
//

import UIKit

class InfoPokemonCell: UITableViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var val1Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var txtTitle: String? {
      didSet {
          statusLabel.text = txtTitle
      }
    }
    var val1: String? {
      didSet {
        val1Label.text = val1
      }
    }
    

}
