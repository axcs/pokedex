//
//  ServiceManager.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//
import Foundation
import UIKit
class ServiceManager : BaseServices{

    override init() {
        super.init()
     
    }

    func getListPokemons(limite: Int, offset: Int, completion: @escaping(_ response: CommonListPokemon?, _ error: String?)-> Void){
           
        self.dataRequest(with: ServicesEndPointsEnum.getListPokemons(LIMITE: limite, OFFSET: offset).endpoint, objectType: CommonListPokemon.self, httpMethod : .get){ (result: BaseResponse) in
                switch result {
                case .success(let modelToReturn):
                    if let model = modelToReturn{
                        completion(model, nil)
                    }else{
                        completion(nil, "Error Parse model")
                        break
                    }
                    break
                case .failure(let error):
                    "failed with error \(error)".errorLog()
                    completion(nil, "failed with error \(error)")
                    break
                }
        }
    }
    
    func getPokemonSpecies(pokemonID: String, completion: @escaping(_ response: CommonPokemonSpecies?, _ error: String?)-> Void){
        self.dataRequest(with: ServicesEndPointsEnum.getPokemonSpecies(ID: pokemonID).endpoint, objectType: CommonPokemonSpecies.self, httpMethod : .get){ (result: BaseResponse) in
                switch result {
                case .success(let modelToReturn):
                    if let model = modelToReturn{
                        completion(model, nil)
                    }else{
                        completion(nil, "Error Parse model")
                        break
                    }
                    break
                case .failure(let error):
                    "failed with error \(error)".errorLog()
                    completion(nil, "failed with error \(error)")
                    break
                }
        }
        
    }
    
    
    func getPokemonByID(pokemonID: String, completion: @escaping(_ response: CommonPokemonModel?, _ error: String?)-> Void){
        self.dataRequest(with: ServicesEndPointsEnum.getPokemonByID(ID: pokemonID).endpoint, objectType: CommonPokemonModel.self, httpMethod : .get){ (result: BaseResponse) in
                switch result {
                case .success(let modelToReturn):
                    if let model = modelToReturn{
                        completion(model, nil)
             
                    }else{
                        completion(nil, "Error Parse model")
                        break
                    }
                    break
                case .failure(let error):
                    "failed with error \(error)".errorLog()
                    completion(nil, "failed with error \(error)")
    
                    break
                }
        }
    }
    
    
    func saveFavorite( pokemonModel: CommonPokemonModel, completion: @escaping(_ response: CommonSavePokemonModel?, _ error: String?)-> Void){
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(pokemonModel)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            let data = (json!.data(using: .utf8))! as Data
            
                self.dataRequest(with: ServicesEndPointsEnum.putFavorite.endpoint, objectType: CommonSavePokemonModel.self, httpMethod : .post, parameters: data){ (result: BaseResponse) in
                    switch result {
                    case .success(_):
                        let savePokemonModel = CommonSavePokemonModel()
                        savePokemonModel.success = true
                        completion(savePokemonModel, nil)
                        break
                    case .failure(let error):
                        "failed with error \(error)".errorLog()
                        completion(nil, "failed with error \(error)")
                        break
                    }
                    
                }
            
        }catch{
            completion(nil, "Invalid Parameters \(error)")

        }
        
    }
    
}
