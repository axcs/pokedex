//
//  CommonPokemonSpecies.swift
//  Pokedex
//
//  Created by axavierc on 24/06/2022.
//
import Foundation

// MARK: - CommonPokemonSpecies
class CommonPokemonSpecies: CommonDataBaseModel, Codable{
    
    let color: ColorData?
    let flavorTextEntries: [FlavorTextEntry]?
    
    
    enum CodingKeys: String, CodingKey {
        
        case color = "color"
        case flavorTextEntries = "flavor_text_entries"
        
    }
}

// MARK: - ColorData
class ColorData: Codable {
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
    let language, version: ColorData
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language = "language"
        case version = "version"
    }
}
