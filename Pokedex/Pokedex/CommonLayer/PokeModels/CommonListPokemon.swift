//
//  CommonListPokemon.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

import Foundation
import UIKit

class CommonListPokemon : CommonDataBaseModel, Codable{
    var count: Int?
    var next: String?
    var previous: String?
    var results: [Result]?
   

    
    override init() {
    }
}

// MARK: - Result
class Result: Codable {
    let name: String
    let url: String

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }

}
