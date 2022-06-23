//
//  PokeCollectionViewCell.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

import UIKit
import SDWebImage

class PokeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pokeTitleLabel: UILabel!
    @IBOutlet weak var pokeDescriptionLabel: UILabel!
    @IBOutlet weak var pokeCellBackgroundView: UIView!
    @IBOutlet weak var pokeImageView: UIImageView!
    @IBOutlet weak var favoriteContainerView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var pokemon: PokemonCollectionViewViewModel? = nil
    var favoriteStatus = false {
        didSet{
            if favoriteStatus {
                UIView.animate(withDuration: 0.3, animations: {
                    self.favoriteContainerView.backgroundColor = UIColor.red
                    self.favoriteButton.tintColor = UIColor.white
                })
                
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.favoriteContainerView.backgroundColor = UIColor.white
                    self.favoriteButton.tintColor = UIColor.black
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(pokemon: PokemonCollectionViewViewModel){
        self.pokemon = pokemon
        self.favoriteStatus = pokemon.favoriteStatus
        self.pokeTitleLabel.text = (pokemon.name)?.firstCapitalized
        self.pokeDescriptionLabel.text = pokemon.description
        
        if let imgURL = pokemon.imageURL {
            pokeImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            pokeImageView.sd_setImage(with: URL(string: imgURL))
        }else{
            pokeImageView.image = UIImage(named: "poke_icon")
        }
        if(pokemon.favoriteAction == nil){
            self.favoriteContainerView.alpha = 0
            self.favoriteButton.isEnabled = false
        }else{
            self.favoriteContainerView.alpha = 1
            self.favoriteButton.isEnabled = true
        }
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        favoriteStatus = !favoriteStatus
        self.pokemon?.favoriteAction?(self.favoriteStatus, pokemon?.id ?? "")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        pokeCellBackgroundView.layer.cornerRadius = 10
        
        // border
        pokeCellBackgroundView.layer.borderWidth = 1.0
        pokeCellBackgroundView.layer.borderColor = UIColor.black.cgColor
        
        // shadow
        pokeCellBackgroundView.layer.shadowColor = UIColor.black.cgColor
        pokeCellBackgroundView.layer.shadowOffset = CGSize(width: 5, height: 10)
        pokeCellBackgroundView.layer.shadowOpacity = 0.4
        pokeCellBackgroundView.layer.shadowRadius = 5.0
 
        favoriteContainerView.layer.shadowOpacity = 0.15
        favoriteContainerView.layer.shadowOffset = CGSize(width: .zero, height: 5)
        favoriteContainerView.layer.borderWidth = 0.5
        favoriteContainerView.layer.borderColor = UIColor.black.cgColor
        
    }
}

class PokemonCollectionViewViewModel {
    var id: String?
    var name : String?
    var description : String = ""
    var imageURL : String? = nil
    
    var favoriteAction: ((_ status: Bool, _ id: String)->())? = nil
    var favoriteStatus = false
    
    init(id: String?, name : String?, description : String, imageURL : String?, favoriteAction: ((_ status: Bool, _ id: String)->())? = nil, favoriteStatus : Bool = false ){
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.favoriteAction = favoriteAction
        self.favoriteStatus = favoriteStatus
    }
}
