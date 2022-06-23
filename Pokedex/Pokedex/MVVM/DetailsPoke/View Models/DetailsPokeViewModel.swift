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
    let listPokemon = Box(CommonListPokemon())

    init() {
        
    }
    
    func getPokemonInfo(index: String, completion: @escaping(_ success: Bool, _ response: DetailsPokeModel?)-> Void){
        self.serviceManager.getPokemonByID(pokemonID: index, subscriber: (self.InteractorID, { ( response: BaseResponse? ) -> Void in
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

    func getAllPokemons(limit: Int, offset: Int ,completion: @escaping(_ sucess: Bool, _ response: CommonListPokemon?)-> Void){
        self.serviceManager.getListPokemons(limite: limit, offset: offset, subscriber: (self.InteractorID, { ( response: BaseResponse? ) -> Void in
            
            if let response = response {
                switch response {
                case .failure(let error):
                    print(error)
                    completion(false, nil)
                    break
                case .success(let model):
                    if let models = model as? CommonListPokemon {
                        completion(true, models)
                        self.listPokemon.value = models
                        return
                    }
                    completion(false, nil)
                    return
                }
            }
        }))
    }

}
