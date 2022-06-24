//
//  ServicesEndPoints.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

import Foundation

enum ServicesEndPointsEnum{
    
    //Add all endpoints here
    case getPokemonByID(ID : String)
    case getListPokemons(LIMITE: Int, OFFSET: Int)
    case putFavorite
    case getPokemonSpecies(ID : String)
    
    
    /**
     This property returns the String of the endpoint with all the arguments
     - Returns: String
     */
    var endpoint : String{
        switch self {
        case .getPokemonByID(let ID):
            return "https://pokeapi.co/api/v2/pokemon/\(ID)"
        case .getListPokemons (let LIMITE, let OFFSET):
            return "https://pokeapi.co/api/v2/pokemon/?limit=\(LIMITE)&offset=\(OFFSET)"
        case .putFavorite:
            return "https://webhook.site/9e4082e7-56c1-496e-9f8f-a4f13996745d"
        case .getPokemonSpecies(let ID):
            return "https://pokeapi.co/api/v2/pokemon-species/\(ID)"
        }
        
 
    }
}

