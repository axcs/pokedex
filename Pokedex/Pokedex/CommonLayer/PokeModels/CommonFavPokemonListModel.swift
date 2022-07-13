//
//  CommonFavPokemonListModel.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//


import Foundation

class CommonFavPokemonListModel : CommonDataBaseModel, Codable{
    var favoritePokemonIDList : [CommonPokemonModel] = []
    
    override init() {
    }
    
    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case favoritePokemonIDList = "favoritePokemonIDList"

    }
}
