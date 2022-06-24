//
//  DetailsPokeModel.swift
//  Pokedex
//
//  Created by axavierc on 23/06/2022.
//

import Foundation
import CoreLocation

struct DetailsPokeModel {
    var pokemon : DetailsPokeModelPokemon?
    var species : SpeciesModelPokemon?
    var allPokemons :AllPokeModelPokemon?
}

class DetailsPokeModelPokemon {
    var id : String?
    var description : String?
    var name : String?
    var height : String?
    var weight : String?
    var imageURL : String?
    var types : String?
    var stats : [CDLStatsModel]?
    
    
    init(cdlModel: CommonPokemonModel) {
        self.id = "\(cdlModel.id ?? 0)"
        var descriptionText = "#"
        let idStr = "\(cdlModel.id ?? 0)"
        descriptionText += idStr.addzeros
        self.description = descriptionText
        self.name = cdlModel.name?.firstCapitalized
        
        let weightAux = Double(cdlModel.weight ?? 0)
        let heightAux = Double(cdlModel.height ?? 0)
 
        self.height = "\(heightAux / 10.0) m"
        self.weight = "\(weightAux / 10.0) kg"

        self.stats = cdlModel.stats
        
        var typesAux: String = ""
        for item in cdlModel.types ?? [] {
            typesAux += (item.type?.name)?.firstCapitalized ?? ""
            typesAux += "; "
        }
        self.types = typesAux
        
        if let sprites = cdlModel.sprites {
            if let sprite = sprites.other{
                self.imageURL = sprite.officialartwork?.front_default
            }else{
                self.imageURL = sprites.front_default
            }
        }
    }
}

class AllPokeModelPokemon{
    var results: [Resultt]?
    
    init(cdlModel: CommonListPokemon) {
        self.results = cdlModel.results
    }
}

class SpeciesModelPokemon {
    var color: ColorData?
    var flavorText: String?
    
    init(cdlModel: CommonPokemonSpecies) {
        self.color = cdlModel.color
        
        let flavorTextEntries = cdlModel.flavorTextEntries
        var flavorDesc = ""
        for flavor in flavorTextEntries ?? [] {
            if (flavor.version.name == "red"){
                flavorDesc = flavor.flavorText
            }
        }
        let fixStr1 = flavorDesc.replacingOccurrences(of: "\\f", with: " ", options: .regularExpression, range: nil)
        let fixStr2 = fixStr1.replacingOccurrences(of: "\n", with: " ", options: .literal, range: nil)
        self.flavorText = fixStr2
    }
}
