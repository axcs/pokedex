//
//  CommonSavePokemonModel.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//


import Foundation

class CommonSavePokemonModel : CommonDataBaseModel, Codable{
    var id : Int?
    var success = false
    override init() {
    }
    
    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case id = "id"

    }
    
}
