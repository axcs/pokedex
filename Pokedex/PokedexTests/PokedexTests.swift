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
        let expectation = XCTestExpectation(description: "get all List Pokemons and bind this list")
        let viewModel = HomeViewModel()
        viewModel.fetchAllPokemons()
        
        
        viewModel.model.bind { value in
                XCTAssertEqual(value.listPokemons.count, 10)
                XCTAssert(value.listPokemons.first?.name == "bulbasaur")
                XCTAssert(value.listPokemons.last?.name == "caterpie")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
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
        wait(for: [expectation], timeout: 1)

    }
    
    func test_VM_saveFavorits() throws {
        let expectation = XCTestExpectation(description: "save favorits, send it for server")
        let viewModel = HomeViewModel()

        viewModel.saveFavorits(id: "2")

        viewModel.saveFavoritsModel.bind { value in
            XCTAssert(value.success == true)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_VM_get_details_Pokemon() throws {
        let expectation = XCTestExpectation(description: "save favorits, send it for server")
        let viewModel = DetailsPokeViewModel()

        viewModel.fetchPokemonInfo("1")

        viewModel.sectionOneData.bind {value in
            XCTAssertEqual(value.count, 5)
            XCTAssert(value.first?.value == "#001")
            XCTAssert(value.last?.value == "Green")
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 1)
    }
    


    
    
}
