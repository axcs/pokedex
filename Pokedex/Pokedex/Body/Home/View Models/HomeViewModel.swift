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
    let pokemonCommon = CommonPokemon()
    let listPokemon = Box(CommonListPokemon())

    init() {
        
    }
    
    
    
    func updateFavoriteStatus(index: String, favoriteStatus: Bool){
        
        self.pokemonCommon.getPokemonByID(pokemonID: index, subscriber: (self.InteractorID, {( response: BaseResponse? ) -> Void in
            if let response = response{
                switch response {
                case .success(let model):
                    if let model = model as? CommonPokemonModel {
                        self.pokemonCommon.saveOrRemoveFavorite(save: favoriteStatus, pokemonModel: model, subscriber: (self.InteractorID, {(response: BaseResponse? ) -> Void in
                            if let favoriteResponse = response {
                                switch favoriteResponse {
                                case .success(_):
                                    print("SUCESSOR")
                                    //                                    completion(true)
                                    return
                                default:
                                    print("FALHOU")
                                    //                                    completion(false)
                                    return
                                }
                            }else{
                                print("FALHOU")
                                //                                completion(false)
                                return
                            }
                        }))
                    }else{
                        print("FALHOU")
                        //                        completion(false)
                        return
                    }
                default:
                    break
                }
            }
        }))
        
    }
    
//    func updateFavoriteStatus(index: Int, favoriteStatus: Bool, completion: @escaping(_ sucess: Bool)-> Void){
//        if let id = self.homeInteractorModel?.pokemon?.id{
//            self.pokemonCommon.getPokemonByID(pokemonID: "\(id)", subscriber: (self.InteractorID, {( response: BaseResponse? ) -> Void in
//                if let response = response{
//                    switch response {
//                    case .success(let model):
//                        if let model = model as? CommonPokemonModel {
//                            self.pokemonCDL.saveOrRemoveFavorite(save: favoriteStatus, pokemonModel: model, subscriber: (self.InteractorID, {(response: BaseResponse? ) -> Void in
//                                if let favoriteResponse = response {
//                                    switch favoriteResponse {
//                                    case .success(_):
//                                        completion(true)
//                                        return
//                                    default:
//                                        completion(false)
//                                        return
//                                    }
//                                }else{
//                                    completion(false)
//                                    return
//                                }
//                            }))
//                        }else{
//                            completion(false)
//                            return
//                        }
//                    default:
//                        break
//                    }
//                }
//            }))
//        }
//    }
    
    
    
    func getPokemonInfo(index: String, completion: @escaping(_ sucess: Bool, _ response: CommonPokemonModel?)-> Void){
        self.pokemonCommon.getPokemonByID(pokemonID: index, subscriber: (self.InteractorID, { ( response: BaseResponse? ) -> Void in
                if let response = response {
                switch response {
                case .failure(_):
                    "cdl responded with failure".errorLog()
                    completion(false, nil)
                    
                    break
                case .success(let model):
                    if let model = model as? CommonPokemonModel {
                        completion(true, model)
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

        self.pokemonCommon.getListPokemons(limite: limit, offset: offset, subscriber: (self.InteractorID, { ( response: BaseResponse? ) -> Void in
            
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
                        
//                        self.pokemonCommon.getPokemonByID(pokemonID: "1", subscriber: (self.InteractorID, { ( response: BaseResponse? ) -> Void in
//
//
//                            if let response = response {
//                                switch response {
//                                case .failure(let error):
//                                    print(error)
//                                    break
//                                case .success(let model):
//                                    if let model = model as? CommonPokemonModel {
//                                        models.poke = model
//
//                                        return
//                                    }
//                                    return
//                                }
//                            }
//
//
//
//
//                        }))
                        return
                    }
                    //                    "no pokemon Found".errorLog()
                    //                          completion(nil , HomeInteractorErrorModel.noPokemonFound)
                    completion(false, nil)
                    return
                }
            }
        }))
        
    }

}

enum HomeInteractorErrorModel {
    case noPokemonFound
    case networkError
    case internalError
    
    static func convertCDLErrorInteractorErrorModel(error: CDLErrorType) -> HomeInteractorErrorModel{
        
        switch error {
        case .networkError(_):
            return .networkError
        default:
            break
        }
        return .internalError
    }
}
