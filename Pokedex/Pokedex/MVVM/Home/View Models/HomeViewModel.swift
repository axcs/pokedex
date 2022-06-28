//
//  HomeViewModel.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

import Foundation
import UIKit.UIImage

public class HomeViewModel {
    var InteractorID = "HomeInteractor"
    let serviceManager = ServiceManager()

    init() {
        
    }

    func getPokemonInfo(index: String, completion: @escaping(_ success: Bool, _ response: HomeModel?)-> Void){
        self.serviceManager.getPokemonByID(pokemonID: index, subscriber: (self.InteractorID, { ( response: BaseResponse? ) -> Void in
                if let response = response {
                switch response {
                case .failure(_):
                    "getPokemonByID responded with failure".errorLog()
                    completion(false, nil)
                    break
                case .success(let model):
                    if let model = model as? CommonPokemonModel {
                        
                        var homeModel = HomeModel()
                        homeModel.pokemon = HomeModelPokemonModel(cmumModel: model) 
                        completion(true, homeModel)
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
                        return
                    }
                    completion(false, nil)
                    return
                }
            }
        }))
    }
    
    func updateFavoriteStatus(idPokemon: String, favoriteStatus: Bool, completion: @escaping(_ success: Bool)-> Void){
        self.serviceManager.getPokemonByID(pokemonID: idPokemon, subscriber: (self.InteractorID, {( response: BaseResponse? ) -> Void in
            if let response = response{
                switch response {
                case .success(let model):
                    if let model = model as? CommonPokemonModel {
                        self.serviceManager.saveOrRemoveFavorite(save: favoriteStatus, pokemonModel: model, subscriber: (self.InteractorID, {(response: BaseResponse? ) -> Void in
                            if let favoriteResponse = response {
                                switch favoriteResponse {
                                case .success(_):
                                    completion(true)
                                    return
                                default:
                                    completion(false)
                                    return
                                }
                            }else{
                                completion(false)
                                return
                            }
                        }))
                    }else{
                        completion(false)
                        return
                    }
                default:
                    break
                }
            }
        }))
    }

}

