//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by axavierc on 21/06/2022.
//

import XCTest
@testable import Pokedex

class PokedexTests: XCTestCase {
    var serviceManager : ServiceManager!
    
    override func setUp(){
        serviceManager = ServiceManager()
    }
    
    func test_Serv_get_all_pokemons() throws {
        let expectation = XCTestExpectation(description: "calls Service for get specific pokemon")
   
        self.serviceManager.getListPokemons(limite: 10, offset: 1, subscriber: ("Apptest", { ( response: BaseResponse? ) -> Void in
            if let response = response {
                switch response {
                case .failure(let error):
                    XCTAssert(false, error.description)
                    break
                case .success(let model):
                    if let model = model as? CommonListPokemon {
                        XCTAssert(model.results?.count == 10)
                        XCTAssert(model.results?.first?.name == "ivysaur")
                        XCTAssert(model.results?.last?.name == "metapod")
                        XCTAssert(model.count != nil)
                        XCTAssert(model.next != nil)
                        XCTAssert(model.previous != nil)
                        
                    }else{
                        XCTAssert(false, "model is not compatible with CommonListPokemon")
                    }
                   
                    break
                }
            }else{
                XCTAssert(false, "no response avaliable")
            }
            expectation.fulfill()
        }))
        wait(for: [expectation], timeout: 1)
    }
    

    func test_Serv_pokemon_by_id() throws {
        let expectation = XCTestExpectation(description: "calls Service for get specific pokemon")
   
        serviceManager.getPokemonByID(pokemonID: "4", subscriber: ("Apptest", { ( response: BaseResponse? ) -> Void in
            if let response = response {
                switch response {
                case .failure(let error):
                    XCTAssert(false, error.description)
                    break
                case .success(let model):
                    if let model = model as? CommonPokemonModel {
                        XCTAssert(model.name == "charmander")
                        XCTAssert(model.stats?.count != 0)
                        XCTAssert(model.stats?[0].base_stat != nil)
                        XCTAssert(model.stats?[0].stat != nil)
                        XCTAssert(model.stats?[0].stat?.name != nil)
                        XCTAssert(model.sprites != nil)
                        XCTAssert(model.sprites?.other != nil)
                        XCTAssert(model.sprites?.other?.officialartwork != nil)
                        XCTAssert(model.height == 6)
                        XCTAssert(model.weight == 85)
                        
                    }else{
                        XCTAssert(false, "model is not compatible with CommonPokemonModel")
                    }
                   
                    break
                }
            }else{
                XCTAssert(false, "no response avaliable")
            }
            expectation.fulfill()
        }))
        wait(for: [expectation], timeout: 1)
    }
    
    func test_save_favorite() throws {
        let expectation = XCTestExpectation(description: "calls Service to save specific pokemon")
        let pokemonToSave = CommonPokemonModel()
        pokemonToSave.id = 4
        pokemonToSave.name = "charmander"
        pokemonToSave.height = 85
        pokemonToSave.weight = 6
        let stat1 = StatsModel()
        stat1.base_stat = 52
        stat1.effort = 0
        stat1.stat = StatDescriptionModel()
        stat1.stat?.name = "hp"
        pokemonToSave.stats = [stat1]
        
        serviceManager.saveOrRemoveFavorite(pokemonModel: pokemonToSave, subscriber: ("Apptest", { ( response: BaseResponse? ) -> Void in
            if let response = response {
                switch response {
                case .failure(let error):
                    XCTAssert(false, error.description)
                    break
                case .success(let model):
                    XCTAssert((model as? CommonSavePokemonModel)?.success == true )
                    break
                }
            }else{
                XCTAssert(false, "no response avaliable")
            }
            expectation.fulfill()
        }))
        
        wait(for: [expectation], timeout: 5)
    }
    
    
    func test_HomeviewModel_get_pokemon_by_valid_id() throws {
        let expectation = XCTestExpectation(description: "calls home interactor layer for specific pokemon")
        let viewModel = HomeViewModel()
        viewModel.getPokemonInfo(index: "4") { success, response in
            XCTAssert(success == true)
            XCTAssert(response != nil)
            XCTAssert(response?.pokemon != nil, "has no pokemon")
            XCTAssert(response?.pokemon?.name != nil , "no name was passed")
            XCTAssert(response?.pokemon?.id != nil , "no id was passed")
            XCTAssert(response?.pokemon?.height != nil , "no height was passed")
            XCTAssert(response?.pokemon?.weight != nil , "no weight was passed")
            XCTAssert(response?.pokemon?.imageURL != nil , "no image was passed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)

    }


    func test_Serv_pokemonSpecies_by_id() throws {
        let expectation = XCTestExpectation(description: "calls Service for get specific pokemon")
   
        serviceManager.getPokemonSpecies(pokemonID: "4", subscriber: ("Apptest", { ( response: BaseResponse? ) -> Void in
            if let response = response {
                switch response {
                case .failure(let error):
                    XCTAssert(false, error.description)
                    break
                case .success(let model):
                    if let model = model as? CommonPokemonSpecies {
                        XCTAssert(model.color?.name == "red")
                        XCTAssert(model.flavorTextEntries != nil)
                        
                    }else{
                        XCTAssert(false, "model is not compatible with CommonPokemonModel")
                    }
                   
                    break
                }
            }else{
                XCTAssert(false, "no response avaliable")
            }
            expectation.fulfill()
        }))
        wait(for: [expectation], timeout: 1)
    }
    

    
    
}
