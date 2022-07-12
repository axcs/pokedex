//
//  HomeViewModel.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

import Foundation
import UIKit.UIImage


protocol HomeViewModelProtocol {
    
    var pokemonsDidChanges: ((Bool, Bool) -> Void)? { get set }
    func fetchAllPokemons()
    func fetchNextPagePokemons()
    func saveFavorits(id: String)
}

class HomeViewModel: HomeViewModelProtocol {

    
    var InteractorID = "HomeInteractor"
    private var pageOffset:Int = 0          // var count offset Page
    private var pageRowsLimite:Int = 10      // var page limite
    let serviceManager = ServiceManager()
    
    init() {
        
    }
    
    var pokemonsDidChanges: ((Bool, Bool) -> Void)?
    
    var model: HomeModel? {
        didSet {
            self.pokemonsDidChanges!(true, false)
        }
    }
    
    
    
    private func getPokemonInfo(index: String, completion: @escaping(_ success: Bool, _ response: CommonPokemonModel?)-> Void){
        self.serviceManager.getPokemonByID(pokemonID: index, subscriber: (self.InteractorID, { ( response: BaseResponse? ) -> Void in
            if let response = response {
                switch response {
                case .failure(_):
                    "getPokemonByID responded with failure".errorLog()
                    completion(false, nil)
                    break
                case .success(let model):
                    if let model = model as? CommonPokemonModel {
                        //                        homeModel.pokemon = HomeModelPokemonModel(cmumModel: model)
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
    
    
    private func getAllPokemons(limit: Int, offset: Int ,completion: @escaping(_ sucess: Bool, _ response: [Result]?)-> Void){
        self.serviceManager.getListPokemons(limite: limit, offset: offset, subscriber: (self.InteractorID, { ( response: BaseResponse? ) -> Void in
            
            if let response = response {
                switch response {
                case .failure(let error):
                    print(error)
                    completion(false, nil)
                    break
                case .success(let model):
                    if let models = model as? CommonListPokemon {
                        completion(true, models.results ?? [])
                        return
                    }
                    completion(false, nil)
                    return
                }
            }
        }))
    }
    
    private func updateFavoriteStatus(idPokemon: String, favoriteStatus: Bool, completion: @escaping(_ success: Bool)-> Void){
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
    
    
    
    
    public func fetchAllPokemons(){
        self.model = HomeModel()
        var auxModel = HomeModel()
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()   // <<---
        self.getAllPokemons(limit: pageRowsLimite, offset: pageOffset) { success, response in
            if success{
                for item in response ?? []{
                    auxModel.listPokemons.append(HomeModelPokemonList(cmumModel: item))
                }
                for poke in auxModel.listPokemons {
                    dispatchGroup.enter()   // <<---
                    self.getPokemonInfo(index: poke.numPoke ?? "") { success, response in
                        
                        dispatchGroup.leave()   // <<----
                        
                        if success{
                            if let pokemonInfo = response {
                                let infoPoke = HomeModelPokemonModel(cmumModel: pokemonInfo)
                                poke.pokemonInfo = infoPoke
                                
                            }
                        }else {
                            "Error on getPokemonInfo Service".errorLog()
                        }
                    }
                   
                }
                dispatchGroup.leave()   // <<----
            }
            else {
                "Error on GetAllPokemons Service".errorLog()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.model = auxModel
        }
        
    }
    
    
    func fetchNextPagePokemons() {
        pageOffset += 10
        
        var auxModel = HomeModel()
        
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()   // <<---
        self.getAllPokemons(limit: pageRowsLimite, offset: pageOffset) { success, response in
            if success{
                for item in response ?? []{
                    auxModel.listPokemons.append(HomeModelPokemonList(cmumModel: item))
                }
                for poke in auxModel.listPokemons {
                    dispatchGroup.enter()   // <<---
                    self.getPokemonInfo(index: poke.numPoke ?? "") { success, response in
                        
                        dispatchGroup.leave()   // <<----
                        
                        if success{
                            if let pokemonInfo = response {
                                let infoPoke = HomeModelPokemonModel(cmumModel: pokemonInfo)
                                poke.pokemonInfo = infoPoke
                                
                            }
                        }else {
                            "Error on getPokemonInfo Service".errorLog()
                        }
                    }
                   
                }
                dispatchGroup.leave()   // <<----
            }
            else {
                "Error on GetAllPokemons Service".errorLog()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.model?.listPokemons += auxModel.listPokemons

        }
    }
    
    func saveFavorits(id: String) {
        self.updateFavoriteStatus(idPokemon: id, favoriteStatus: true) { success in
            
            if success {
//                self.showMsg(msg: "Favorite sent successfully!")
            }
            else{
//                self.showError(msg: "Error sending favorite")
            }
            
        }
    }
    


}

