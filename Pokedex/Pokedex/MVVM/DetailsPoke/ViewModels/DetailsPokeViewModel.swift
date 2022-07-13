//
//  DetailsPokeViewModel.swift
//  Pokedex
//
//  Created by axavierc on 22/06/2022.
//

import Foundation
import UIKit.UIImage

protocol DetailsPokeViewModelProtocol {
    func fetchPokemonInfo(_ idPoke: String)
    func saveFavorits(id: String) 
}

public class DetailsPokeViewModel: DetailsPokeViewModelProtocol {
    
    private let serviceManager = ServiceManager()
    var error:DynamicType<String> = DynamicType<String>()
    var model:DynamicType<DetailsPokeModel> = DynamicType<DetailsPokeModel>()
    var sectionOneData:DynamicType<[DescValueObj]> = DynamicType<[DescValueObj]>()
    var introData:DynamicType<SpeciesModelPokemon> = DynamicType<SpeciesModelPokemon>()
    var saveFavoritsModel:DynamicType<CommonSavePokemonModel> = DynamicType<CommonSavePokemonModel>()

    
    init() {
    }
    
    func fetchPokemonInfo(_ idPoke: String) {
        let dispatchGroup = DispatchGroup()
        var auxModel = DetailsPokeModel()
        var pokemonObj : [DescValueObj] = []
        var speciesData: SpeciesModelPokemon?
        
        dispatchGroup.enter()
        self.serviceManager.getPokemonByID(pokemonID: idPoke) { response, error in
            if let response = response {
                auxModel.pokemon = DetailsPokeModelPokemon(cmumModel: response)

                let numberObj = DescValueObj(desc: "detail_number".localized, value: auxModel.pokemon?.description ?? "")
                pokemonObj.append(numberObj)
                let weightObj = DescValueObj(desc: "detail_height".localized, value: auxModel.pokemon?.weight ?? "")
                pokemonObj.append(weightObj)
                let heightObj = DescValueObj(desc: "detail_weight".localized, value: auxModel.pokemon?.height ?? "")
                pokemonObj.append(heightObj)
                let typesObj = DescValueObj(desc: "detail_types".localized, value: auxModel.pokemon?.types ?? "")
                pokemonObj.append(typesObj)
                

                dispatchGroup.enter()
                self.serviceManager.getPokemonSpecies(pokemonID: idPoke) { responseSpecies, error in
                    if let responseSp = responseSpecies {
                        speciesData = SpeciesModelPokemon(cmumModel: responseSp)
                        let typesObj = DescValueObj(desc: "detail_color".localized, value: speciesData?.color ?? "")
                        pokemonObj.append(typesObj)
                        
                    }else {
                        self.error.value = error
                    }
                    dispatchGroup.leave()
                }
                
                
            }else {
                self.error.value = error
            }
            dispatchGroup.leave()  
        }
        
        dispatchGroup.notify(queue: .main) {
            self.model.value = auxModel
            self.sectionOneData.value = pokemonObj
            self.introData.value = speciesData
        }
    }
    
    func saveFavorits(id: String) {
        self.serviceManager.getPokemonByID(pokemonID: id) { response, error in
            if let response = response {
                self.serviceManager.saveFavorite(pokemonModel: response) { responseFav, error in
                    if responseFav?.success == true {
                        self.saveFavoritsModel.value = responseFav
                        "SAVE OK".sucessLog()
                    }else{
                        self.saveFavoritsModel.value = responseFav
                        self.error.value = error
                    }
                }
                
            }else{
                self.error.value = error
            }
        }
    }
    
}
