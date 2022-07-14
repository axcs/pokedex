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
    
    func test_VM_get_all_pokemons() throws {
        let expectation = XCTestExpectation(description: "test get all List Pokemons and bind this list")
        let viewModel = HomeViewModel()
        viewModel.fetchAllPokemons()
        
        
        viewModel.model.bind { value in
                XCTAssertEqual(value.listPokemons.count, 10)
                XCTAssert(value.listPokemons.first?.name == "bulbasaur")
                XCTAssert(value.listPokemons.last?.name == "caterpie")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func test_VM_get_NextPage_pokemons() throws {
        let expectation = XCTestExpectation(description: "get next Page Pokemons and bind this list")
        let viewModel = HomeViewModel()

        viewModel.fetchNextPagePokemons()

        viewModel.model.bind { value in
                XCTAssertEqual(value.listPokemons.count, 10)
                XCTAssert(value.listPokemons.first?.name == "metapod")
                XCTAssert(value.listPokemons.last?.name == "raticate")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)

    }
    
    func test_VM_saveFavorits() throws {
        let expectation = XCTestExpectation(description: "save favorits, send it for server")
        let viewModel = HomeViewModel()
   
        viewModel.saveFavorits(id: "2")

        viewModel.saveFavoritsModel.bind { value in
            XCTAssert(value.success == true)
            if !value.success {
                XCTAssert(false, "no response avaliable")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4)
    }
    
    func test_VM_get_details_Pokemon() throws {
        let expectation = XCTestExpectation(description: "test get details of pokemon")
        let viewModel = DetailsPokeViewModel()

        viewModel.fetchPokemonInfo("1")

        viewModel.sectionOneData.bind {value in
            XCTAssertEqual(value.count, 6)
            XCTAssert(value.first?.value == "#001")
            XCTAssert(value.last?.value == "Green")
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 3)
    }
    
    func test_Bussi_ConvertUnits() throws {
        let expectation = XCTestExpectation(description: "Checks if unit conversions are correct")
        let defaults = UserDefaults.standard
        let model = DetailsPokeModelPokemon("12", "12")
        if defaults.bool(forKey: USER_SETTINGS_HEIGHT){
            XCTAssert(model.height == "1.2 m")
        }
        else{
            XCTAssert(model.height == "0.4 ft")
        }
        
        if defaults.bool(forKey: USER_SETTINGS_WEIGHT){
            XCTAssert(model.weight == "1.2 kg")
        }else{
            XCTAssert(model.weight == "2.6 lbs")
        }
        
        
        expectation.fulfill()
        wait(for: [expectation], timeout: 3)
    }
    
    
    
}
