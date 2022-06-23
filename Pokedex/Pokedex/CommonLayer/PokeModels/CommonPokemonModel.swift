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
    var stats : [CDLStatsModel]?
    var sprites : CDLspritesModel?
    var weight : Int?
    var types : [TypeElement]?
    
    override init() {
        //TODO
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

class CDLStatsModel: CommonDataBaseModel, Codable {
    var base_stat : Int?
    var effort : Int?
    var stat :CDLStatDescriptionModel?
    
    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case base_stat = "base_stat"
        case effort = "effort"
        case stat = "stat"
    }
}

class CDLStatDescriptionModel: CommonDataBaseModel, Codable {
    var name : String?
    var url : String?
    
    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}

class CDLspritesModel: CommonDataBaseModel, Codable  {
    var back_default : String?
    var front_default : String?
    var other : CDLSpritesOtherModel?
    
    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case back_default = "back_default"
        case front_default = "front_default"
        case other = "other"
    }
}

class CDLSpritesOtherModel: CommonDataBaseModel, Codable {
    var officialartwork : CDLSpritesOtherOfficialartworkModel?
    var home : CDLSpritesOtherOfficialartworkModel?
    
    //enum to match model properties and JSON names
    enum CodingKeys: String, CodingKey {
        case officialartwork = "official-artwork"
        case home = "home"
    }
}

class CDLSpritesOtherOfficialartworkModel: CommonDataBaseModel, Codable {
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


