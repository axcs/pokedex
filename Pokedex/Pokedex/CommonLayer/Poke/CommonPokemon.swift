//
//  CommonPokemon.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

//

import Foundation
import UIKit
class CommonPokemon : BaseServices{
    
    let favoritePokemonList = "favoritePokemonList"
    
    override init() {
        super.init()
        cacheID = "CDLPokemon"
    }
    
    
    func getListPokemons(limite: Int, offset: Int, subscriber: CommonDataSubscriber){
           
        self.dataRequest(with: LayerEndPointsBuilderEnum.getListPokemons(LIMITE: limite, OFFSET: offset).endpoint, objectType: CommonListPokemon.self, httpMethod : .get){ (result: BaseResponse) in
                switch result {
                case .success(let modelToReturn):
                    if let model = modelToReturn{
                        let response = BaseResponse.success(model as CommonDataBaseModel)
//                        CommonData.shared.saveToCache(cacheID: pokemonID, model: model as CommonDataBaseModel)
                        subscriber.1(response)
                    }else{
                        let response = BaseResponse<CommonDataBaseModel>.failure(CDLErrorType.noDataError)
                        subscriber.1(response)
                        break
                    }
                    break
                case .failure(let error):
//                    "failed with error \(error)".errorLog()
                    let response = BaseResponse<CommonDataBaseModel>.failure(error)
                    subscriber.1(response)
                    break
                }
        }
        
   
    }
    
    func getPokemonByID(pokemonID: String, subscriber: CommonDataSubscriber){
       
        if let pokemonModel = CommonData.shared.returnFromCache(cacheID: pokemonID){
            //pokemon is saved in cache and will be reused
            let response = BaseResponse.success(pokemonModel)
            subscriber.1(response)
            return
        }
        
        self.dataRequest(with: LayerEndPointsBuilderEnum.getPokemonByID(ID: pokemonID).endpoint, objectType: CommonPokemonModel.self, httpMethod : .get){ (result: BaseResponse) in
                switch result {
                case .success(let modelToReturn):
                    if let model = modelToReturn{
                        let response = BaseResponse.success(model as CommonDataBaseModel)
                        CommonData.shared.saveToCache(cacheID: pokemonID, model: model as CommonDataBaseModel)
                        subscriber.1(response)
                    }else{
                        let response = BaseResponse<CommonDataBaseModel>.failure(CDLErrorType.noDataError)
                        subscriber.1(response)
                        break
                    }
                    break
                case .failure(let error):
//                    "failed with error \(error)".errorLog()
                    let response = BaseResponse<CommonDataBaseModel>.failure(error)
                    subscriber.1(response)
                    break
                }
        }
    }
    
    func getFavoriteList(subscriber: CommonDataSubscriber){
        //returns favorite from cache since there is no service avaliable to save 
        if let favoriteList = CommonData.shared.returnFromCache(cacheID: self.favoritePokemonList){
            let response = BaseResponse.success(favoriteList as CommonDataBaseModel)
            subscriber.1(response)
        }else{
            let response = BaseResponse<CommonDataBaseModel>.failure(CDLErrorType.noDataError)
            subscriber.1(response)
        }
        
    }
    
    func saveOrRemoveFavorite(save: Bool = true, pokemonModel: CommonPokemonModel, subscriber: CommonDataSubscriber){
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(pokemonModel)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            let data = (json!.data(using: .utf8))! as Data
            
            if(save){
                self.dataRequest(with: LayerEndPointsBuilderEnum.putFavorite.endpoint, objectType: CommonSavePokemonModel.self, httpMethod : .post, parameters: data){ (result: BaseResponse) in
                    switch result {
                    case .success(_):
                        
                        //save to cache
                        if let favoriteList = CommonData.shared.returnFromCache(cacheID: self.favoritePokemonList) as? CommonFavPokemonListModel{
                            CommonData.shared.removeFromCache(cacheID: self.favoritePokemonList)
                            favoriteList.favoritePokemonIDList.append(pokemonModel)
                            CommonData.shared.saveToCache(cacheID: self.favoritePokemonList, model: favoriteList)
                        }else{
                            let favoriteList = CommonFavPokemonListModel()
                            favoriteList.favoritePokemonIDList.append(pokemonModel)
                            CommonData.shared.saveToCache(cacheID: self.favoritePokemonList, model: favoriteList)
                        }
                        
                        let cdlSavePokemonModel = CommonSavePokemonModel()
                        cdlSavePokemonModel.success = true
                        let response = BaseResponse.success(cdlSavePokemonModel as CommonDataBaseModel)
                        subscriber.1(response)
                        break
                    case .failure(let error):
//                        "failed with error \(error)".errorLog()
                        let response = BaseResponse<CommonDataBaseModel>.failure(error)
                        subscriber.1(response)
                        break
                    }
                    
                }
            }else{
                if let favoriteList = CommonData.shared.returnFromCache(cacheID: self.favoritePokemonList) as? CommonFavPokemonListModel{
                    CommonData.shared.removeFromCache(cacheID: self.favoritePokemonList)
                    let newfavoriteList = favoriteList.favoritePokemonIDList.filter{ $0.id != pokemonModel.id}
                    favoriteList.favoritePokemonIDList = newfavoriteList
                    CommonData.shared.saveToCache(cacheID: self.favoritePokemonList, model: favoriteList)
                    
                    let cdlSavePokemonModel = CommonSavePokemonModel()
                    cdlSavePokemonModel.success = true
                    let response = BaseResponse.success(cdlSavePokemonModel as CommonDataBaseModel)
                    subscriber.1(response)
                }else{
                    let response = BaseResponse<CommonDataBaseModel>.failure(CDLErrorType.noDataError)
                    subscriber.1(response)
                }
            }

            
            
        }catch{
            let response = BaseResponse<CommonDataBaseModel>.failure(CDLErrorType.invalidParameters)
            subscriber.1(response)
        }

    }
    
}