//
//  PokemonsModel.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//
import Foundation
import CoreLocation

struct HomeModel {
    
    var listPokemons : [HomeModelPokemonList] =  []
}



class HomeModelPokemonList {
    var name: String?
    var url: String?
    var numPoke: String?
    var pokemonInfo: HomeModelPokemonModel?
    
    
    init(cmumModel: Result) {
        self.name = cmumModel.name
        self.url = cmumModel.url
        let listItems = url?.components(separatedBy: "/")
        self.numPoke = listItems?[6] 
        
    }

}

class HomeModelPokemonModel {
    var id : String?
    var description : String?
    var name : String?
    var height : Int?
    var weight : Int?
    var imageURL : String?
    
    init(cmumModel: CommonPokemonModel) {
        self.id = "\(cmumModel.id ?? 0)"
        var descriptionText = "#"
        let idStr = "\(cmumModel.id ?? 0)"
        descriptionText += idStr.addzeros
        self.description = descriptionText
        self.name = cmumModel.name
        self.height = cmumModel.height
        self.weight = cmumModel.weight
        if let sprites = cmumModel.sprites {
            if let sprite = sprites.other{
                self.imageURL = sprite.officialartwork?.front_default
            }else{
                self.imageURL = sprites.front_default
            }
        }
    }
}
