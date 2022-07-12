//
//  HomeViewModel.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

import Foundation
import UIKit.UIImage


protocol HomeViewModelProtocol {
    func fetchAllPokemons()
    func fetchNextPagePokemons()
    func saveFavorits(id: String)
}

class HomeViewModel: HomeViewModelProtocol {
    
    private var pageOffset:Int = 0          // var count offset Page
    private var pageRowsLimite:Int = 10      // var page limite
    private let serviceManager = ServiceManager()
    var error:DynamicType<String> = DynamicType<String>()
    var model:DynamicType<HomeModel> = DynamicType<HomeModel>()
    var saveFavoritsModel:DynamicType<CommonSavePokemonModel> = DynamicType<CommonSavePokemonModel>()
    
    init() {
        
    }

    public func fetchAllPokemons(){
        var auxModel = HomeModel()
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()   // <<---
        self.serviceManager.getListPokemons(limite: pageRowsLimite, offset: pageOffset) { response, error in
            
            if let response = response {
                for item in response.results ?? []{
                    auxModel.listPokemons.append(HomeModelPokemonList(cmumModel: item))
                }
                for poke in auxModel.listPokemons {
                    dispatchGroup.enter()   // <<---
                    
                    self.serviceManager.getPokemonByID(pokemonID: poke.numPoke ?? "") { responseInfo, error in
                        dispatchGroup.leave()   // <<----
                        if let responsePoke = responseInfo {
                            let infoPoke = HomeModelPokemonModel(cmumModel: responsePoke)
                            poke.pokemonInfo = infoPoke
                        }else {
                            self.error.value = error
                        }
                    }
                    
                }
                dispatchGroup.leave()   // <<----
                
            }else {
                "Error on GetAllPokemons Service".errorLog()
                self.error.value = error
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.model.value = auxModel
        }
        
    }
    
    
    func fetchNextPagePokemons() {
        pageOffset += 10
        var auxModel = HomeModel()
        let dispatchGroup = DispatchGroup()
        auxModel.listPokemons = self.model.value?.listPokemons ?? []
        dispatchGroup.enter()   // <<---
        self.serviceManager.getListPokemons(limite: pageRowsLimite, offset: pageOffset) { response, error in
            
            if let response = response {
                for item in response.results ?? []{
                    auxModel.listPokemons.append(HomeModelPokemonList(cmumModel: item))
                }
                for poke in auxModel.listPokemons {
                    dispatchGroup.enter()   // <<---
                    
                    self.serviceManager.getPokemonByID(pokemonID: poke.numPoke ?? "") { response, error in
                        dispatchGroup.leave()   // <<----
                        if let response = response {
                            let infoPoke = HomeModelPokemonModel(cmumModel: response)
                            poke.pokemonInfo = infoPoke
                        }else {
                            self.error.value = error
                        }
                    }
                    
                }
                dispatchGroup.leave()   // <<----
                
            }else {
                "Error on GetAllPokemons Service".errorLog()
                self.error.value = error
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.model.value = auxModel
            
        }
    }
    
    func saveFavorits(id: String) {
        self.serviceManager.getPokemonByID(pokemonID: id) { response, error in
            if let response = response {
                self.serviceManager.saveFavorite(pokemonModel: response) { responseFav, error in
                    if responseFav != nil {
                        self.saveFavoritsModel.value = responseFav
                        "SUCESSO SAVE".sucessLog()
                    }else{
                        self.error.value = error
                    }
                }
                
            }else{
                self.error.value = error
            }
        }
        
    }
}

