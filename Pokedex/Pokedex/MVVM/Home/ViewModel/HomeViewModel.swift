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
    
    private var pageOffset:Int = 0                 // var count offset Page
    private var pageRowsLimite:Int = 10            // var page limite
    private let serviceManager = ServiceManager()  // var service Manager
    
    
    var error:DynamicType<String> = DynamicType<String>()
    var model:DynamicType<HomeModel> = DynamicType<HomeModel>()
    var saveFavoritsModel:DynamicType<CommonSavePokemonModel> = DynamicType<CommonSavePokemonModel>()
    
    init() {
        
    }

    /**
     This Func  get list of pokemons
     - The List is binding for model
     */
    public func fetchAllPokemons(){
        var auxModel = HomeModel()
        let dispatchGroup = DispatchGroup() // Create  Dispatch Group
        
        dispatchGroup.enter() // Enter task 1
        self.serviceManager.getListPokemons(limite: pageRowsLimite, offset: pageOffset) { response, error in
            
            if let response = response {
                for item in response.results ?? []{
                    auxModel.listPokemons.append(HomeModelPokemonList(cmumModel: item))
                }
                for poke in auxModel.listPokemons {
                    dispatchGroup.enter() // Enter task 2
                    
                    self.serviceManager.getPokemonByID(pokemonID: poke.numPoke ?? "") { responseInfo, error in
                        dispatchGroup.leave() // Leave task 2
                        if let responsePoke = responseInfo {
                            let infoPoke = HomeModelPokemonModel(cmumModel: responsePoke)
                            poke.pokemonInfo = infoPoke
                        }else {
                            self.error.value = error
                        }
                    }
                    
                }
                dispatchGroup.leave() // Leave task 1
                
            }else {
                "Error on GetAllPokemons Service".errorLog()
                self.error.value = error
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.model.value = auxModel
        }
        
    }
    
    /**
     This Func  get list of pokemons of next page
     - The List is binding for model
     */
    func fetchNextPagePokemons() {
        pageOffset += 10
        var auxModel = HomeModel()
        let dispatchGroup = DispatchGroup() // Create  Dispatch Group
        auxModel.listPokemons = self.model.value?.listPokemons ?? []
        dispatchGroup.enter()  // Enter task 1
        self.serviceManager.getListPokemons(limite: pageRowsLimite, offset: pageOffset) { response, error in
            
            if let response = response {
                for item in response.results ?? []{
                    auxModel.listPokemons.append(HomeModelPokemonList(cmumModel: item))
                }
                for poke in auxModel.listPokemons {
                    dispatchGroup.enter()    // Enter task 2
                    
                    self.serviceManager.getPokemonByID(pokemonID: poke.numPoke ?? "") { response, error in
                        dispatchGroup.leave()   // Leave task 2
                        if let response = response {
                            let infoPoke = HomeModelPokemonModel(cmumModel: response)
                            poke.pokemonInfo = infoPoke
                        }else {
                            self.error.value = error
                        }
                    }
                    
                }
                dispatchGroup.leave()  // Leave task 1
                
            }else {
                "Error on GetAllPokemons Service".errorLog()
                self.error.value = error
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.model.value = auxModel
            
        }
    }
    
    /**
     This Func  save pokemon on server
     - The response is binding for saveFavoritsModel
     */
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

