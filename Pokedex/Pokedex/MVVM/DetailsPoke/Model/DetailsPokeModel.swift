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
}

class DetailsPokeModelPokemon {
    var id : String?
    var description : String?
    var name : String?
    var height : String?
    var weight : String?
    var imageURL : String?
    var types : String?
    var stats : [StatsModel]?
    
    init(_ weight:String,_ height: String) {
        let weightAux = Double(weight) ?? 0.0
        let heightAux = Double(height) ?? 0.0
        self.height = getHeightConverted(heightAux)
        self.weight = getWeightConverted(weightAux)
    }
    
    init(cmumModel: CommonPokemonModel) {
        self.id = "\(cmumModel.id ?? 0)"
        var descriptionText = "#"
        let idStr = "\(cmumModel.id ?? 0)"
        descriptionText += idStr.addzeros
        self.description = descriptionText
        self.name = cmumModel.name?.firstCapitalized
        
        let weightAux = Double(cmumModel.weight ?? 0)
        let heightAux = Double(cmumModel.height ?? 0)

        self.height = getHeightConverted(heightAux)
        self.weight = getWeightConverted(weightAux)

        self.stats = cmumModel.stats
        
        var typesAux: String = ""
        var cont: Int = 1
        for item in cmumModel.types ?? [] {
            typesAux += (item.type?.name)?.firstCapitalized ?? ""
            if (cmumModel.types?.count ?? 0 > 1 && cont < cmumModel.types?.count ?? 0 ) {
                typesAux += " / "
            }
            cont = cont + 1
        }
        self.types = typesAux
        
        if let sprites = cmumModel.sprites {
            if let sprite = sprites.other{
                self.imageURL = sprite.officialartwork?.front_default
            }else{
                self.imageURL = sprites.front_default
            }
        }
    }
    
    func getWeightConverted(_ weight: Double) -> String{
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "UseKG") {
            return "\(weight / 10.0) \("detail_kg".localized)"
        }
        let formatValue: String = String(format: "%.1f", (weight * 0.22046))

        return "\(formatValue) \("detail_lb".localized)"
    }
    
    func getHeightConverted(_ height: Double) -> String{
       
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "UseM") {
            return "\(height / 10.0) \("detail_m".localized)"
        }
        let formatValue: String = String(format: "%.1f", (height * 0.03280))
        return "\(formatValue) \("detail_feet".localized)"
    }
   
}

class AllPokeModelPokemon{
    var results: [Result]?
    
    init(cmumModel: CommonListPokemon) {
        self.results = cmumModel.results
    }
}

class SpeciesModelPokemon {
    var color: String?
    var flavorText: String?
    var habitat: String?
    
    init(cmumModel: CommonPokemonSpecies) {
        self.color = cmumModel.color?.name.firstCapitalized
        self.habitat = cmumModel.habitat?.name.firstCapitalized
        let flavorTextEntries = cmumModel.flavorTextEntries
        var flavorDesc = ""
        for flavor in flavorTextEntries ?? [] {
            // get description pokemon version "red"
            if (flavor.version.name == "red"){
                flavorDesc = flavor.flavorText
            }
        }
        // Formatting description by removing the an unnecessary characters
        let formatStr1 = flavorDesc.replacingOccurrences(of: "\\f", with: " ", options: .regularExpression, range: nil)
        let formatStr2 = formatStr1.replacingOccurrences(of: "\n", with: " ", options: .literal, range: nil)
        self.flavorText = formatStr2
    }
}

class DescValueObj{
    var desc: String?
    var value: String?
    
    init(desc: String, value: String) {
        self.desc = desc
        self.value = value
    }
    
}

