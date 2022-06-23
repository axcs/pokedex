//
//  PokemonsModel.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//
import Foundation
import CoreLocation

struct PokemonsModel {
    var idHome: String?
    var pokemon : HomeInteractorPokemonModel?
    var listPokemon : CommonListPokemon?
  

}

class HomeInteractorPokemonModel {
    var id : Int?
    var name : String?
    var height : Int?
    var imageURL : String?
    
    init(cdlModel: CommonPokemonModel) {
        self.id = cdlModel.id
        self.name = cdlModel.name
        self.height = cdlModel.height
        if let sprites = cdlModel.sprites {
            if let sprite = sprites.other{
                self.imageURL = sprite.officialartwork?.front_default
            }else{
                self.imageURL = sprites.front_default
            }
        }
    }
}

