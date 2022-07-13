//
//  HeaderPokemonCell.swift
//  Pokedex
//
//  Created by axavierc on 28/06/2022.
//

import UIKit
import SDWebImage

class HeaderPokemonCell: UITableViewCell {
    
    @IBOutlet weak var imageViewPoke: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var favoriteContainerView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    var headerPoke: HeaderPokemonCellViewModel? = nil
    
    var favoriteStatus = false {
        didSet{
            if favoriteStatus {
                UIView.animate(withDuration: 0.5, animations: {
                    self.favoriteContainerView.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.3, alpha: 1)
                    self.favoriteButton.tintColor = UIColor.white
                })
            }else{
                UIView.animate(withDuration: 0.5, animations: {
                    self.favoriteContainerView.backgroundColor = UIColor(named: "favoritebtn")
                    self.favoriteButton.tintColor = UIColor.black
                })
            }
        }
    }
    
    
    func setup(headerPokemon: HeaderPokemonCellViewModel){
        self.headerPoke = headerPokemon
        self.descLabel.text = headerPokemon.description
        self.favoriteStatus = headerPokemon.favoriteStatus

        if let imgURL = headerPokemon.imageURL {
            imageViewPoke.sd_imageIndicator = SDWebImageActivityIndicator.large
            imageViewPoke.sd_setImage(with: URL(string: imgURL))
        }else{
            imageViewPoke.image = UIImage(named: "background")
        }
        if(headerPokemon.favoriteAction == nil){
            self.favoriteContainerView.alpha = 0
            self.favoriteButton.isEnabled = false
        }else{
            self.favoriteContainerView.alpha = 1
            self.favoriteButton.isEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initComp()
    }
    
    func initComp(){
        imageViewPoke.layer.shadowColor = UIColor.black.cgColor
        imageViewPoke.layer.shadowOffset = CGSize(width: 6, height: 9)
        imageViewPoke.layer.shadowOpacity = 0.5
        imageViewPoke.layer.shadowRadius = 5.0
        
        favoriteContainerView.layer.shadowOpacity = 0.15
        favoriteContainerView.layer.shadowOffset = CGSize(width: .zero, height: 5)
        favoriteContainerView.layer.borderWidth = 0.5
        favoriteContainerView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        favoriteStatus = !favoriteStatus
        if favoriteStatus {
            self.headerPoke?.favoriteAction?( headerPoke?.id ?? "")
        }
    }
    
    

}

class HeaderPokemonCellViewModel {
    var id: String?
    var description : String = ""
    var imageURL : String? = nil
    
    var favoriteAction: ((_ id: String)->())? = nil
    var favoriteStatus = false
    
    init(id: String?, description : String, imageURL : String?,favoriteAction: (( _ id: String)->())? = nil, favoriteStatus : Bool = false ){
        self.id = id
        self.description = description
        self.imageURL = imageURL
        self.favoriteAction = favoriteAction
        self.favoriteStatus = favoriteStatus
    }
}
