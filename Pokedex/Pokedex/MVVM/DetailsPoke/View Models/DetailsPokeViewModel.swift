//
//  DetailsPokeViewModel.swift
//  Pokedex
//
//  Created by axavierc on 22/06/2022.
//

import Foundation
import UIKit.UIImage

public class DetailsPokeViewModel {
    var InteractorID = "HomeInteractor"
    let serviceManager = ServiceManager()
    var dtModel = DetailsPokeModel()
    
    init() {
        
    }
    
    func getPokemonInfo(id: String, completion: @escaping(_ success: Bool, _ response: DetailsPokeModel?)-> Void){
        self.serviceManager.getPokemonByID(pokemonID: id, subscriber: (self.InteractorID, { ( response: BaseResponse? ) -> Void in
                if let response = response {
                switch response {
                case .failure(_):
                    "getPokemonByID responded with failure".errorLog()
                    completion(false, nil)
                    break
                case .success(let model):
                    if let model = model as? CommonPokemonModel {
                        
                        var dtModel = DetailsPokeModel()
                        dtModel.pokemon = DetailsPokeModelPokemon(cdlModel: model)
                        completion(true, dtModel)
                        return
                    }
                    "no pokemon Found".errorLog()
                    completion(false, nil)
                    return
                }
            }
        }))
    }
    
    
    func getPokemonSpecies(id: String, completion: @escaping(_ success: Bool, _ response: DetailsPokeModel?)-> Void){
        self.serviceManager.getPokemonSpecies(pokemonID: id, subscriber: (self.InteractorID, { ( response: BaseResponse? ) -> Void in
                if let response = response {
                switch response {
                case .failure(_):
                    "getPokemonSpecies responded with failure".errorLog()
                    completion(false, nil)
                    break
                case .success(let model):
                    if let model = model as? CommonPokemonSpecies {
                        self.dtModel.species = SpeciesModelPokemon(cdlModel: model)
                        completion(true, self.dtModel)
                        return
                    }
                    "no pokemon Found".errorLog()
                    completion(false, nil)
                    return
                }
            }
        }))
    }
    
    
    
    

    func getAllPokemons(limit: Int, offset: Int ,completion: @escaping(_ sucess: Bool, _ response: DetailsPokeModel?)-> Void){
        self.serviceManager.getListPokemons(limite: limit, offset: offset, subscriber: (self.InteractorID, { ( response: BaseResponse? ) -> Void in
            
            if let response = response {
                switch response {
                case .failure(let error):
                    print(error)
                    completion(false, nil)
                    break
                case .success(let model):
                    if let models = model as? CommonListPokemon {
                        self.dtModel.allPokemons = AllPokeModelPokemon(cdlModel: models)
                        completion(true, self.dtModel)
                        return
                    }
                    completion(false, nil)
                    return
                }
            }
        }))
    }

}
