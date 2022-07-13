//
//  CommonPokemonModel.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

//

import Foundation
import UIKit

class CommonPokemonModel : CommonDataBaseModel, Codable{
    var id : Int?
    var name : String?
    var height : Int?
    var stats : [StatsModel]?
    var sprites : SpritesModel?
    var weight : Int?
    var types : [TypeElement]?
    
    override init() {
    }
    
    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case height = "height"
        case stats = "stats"
        case sprites = "sprites"
        case weight = "weight"
        case types = "types"
    }
    
}

class StatsModel: CommonDataBaseModel, Codable {
    var base_stat : Int?
    var effort : Int?
    var stat :StatDescriptionModel?
    
    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case base_stat = "base_stat"
        case effort = "effort"
        case stat = "stat"
    }
}

class StatDescriptionModel: CommonDataBaseModel, Codable {
    var name : String?
    var url : String?
    
    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}

class SpritesModel: CommonDataBaseModel, Codable  {
    var back_default : String?
    var front_default : String?
    var other : SpritesOtherModel?
    
    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case back_default = "back_default"
        case front_default = "front_default"
        case other = "other"
    }
}

class SpritesOtherModel: CommonDataBaseModel, Codable {
    var officialartwork : SpritesOtherOfficialartworkModel?
    var home : SpritesOtherOfficialartworkModel?
    
    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case officialartwork = "official-artwork"
        case home = "home"
    }
}

class SpritesOtherOfficialartworkModel: CommonDataBaseModel, Codable {
    var front_default : String?
    
    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case front_default = "front_default"
    }
}

// MARK: - TypeElement
class TypeElement: CommonDataBaseModel, Codable {
    let slot: Int?
    let type: Species?

    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case slot = "slot"
        case type = "type"
 
    }
}

class Species: Codable {
    let name: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
 
    }
}


