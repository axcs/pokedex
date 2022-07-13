//
//  CommonPokemonSpecies.swift
//  Pokedex
//
//  Created by axavierc on 24/06/2022.
//
import Foundation

// MARK: - CommonPokemonSpecies
class CommonPokemonSpecies: CommonDataBaseModel, Codable{
    
    let color: DataObj?
    let flavorTextEntries: [FlavorTextEntry]?
    let habitat: DataObj?
    
    
    enum CodingKeys: String, CodingKey {
        
        case color = "color"
        case flavorTextEntries = "flavor_text_entries"
        case habitat = "habitat"
        
    }
}

// MARK: - DataObj
class DataObj: Codable {
    let name: String
    let url: String
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}


// MARK: - FlavorTextEntry
class FlavorTextEntry: Codable {
    let flavorText: String
    let language, version: DataObj
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language = "language"
        case version = "version"
    }
}
