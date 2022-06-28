//
//  CommonData.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

import Foundation
import UIKit

typealias CommonDataNotificationBlock =  ((_: BaseResponse<CommonDataBaseModel> ) -> Void)
typealias CommonDataSubscriber = (String, CommonDataNotificationBlock)
class CommonData {
    
    public static var shared : CommonData = CommonData()
    
    private var commonDataCache : Dictionary<String, CommonDataBaseModel> = Dictionary<String, CommonDataBaseModel>()
    private var commonDataNotificationList : Dictionary<String, [CommonDataSubscriber]> = Dictionary<String, [CommonDataSubscriber]>()
    
    
    private init(){
        
    }
    
    func notifyChanges(cacheID: String){
        if let listToNotify = commonDataNotificationList[cacheID] {
            for notify in listToNotify {
                if let responseModel = commonDataCache[cacheID] {
                    let response = BaseResponse.success(responseModel)
                    notify.1(response)
                }
            }
        }
    }
    
    // notification will send the CommonDataLayerBaseModel
    func subscribe(cacheID: String, subscriber : CommonDataSubscriber){
        if let notificationList = commonDataNotificationList[cacheID] {
            if(notificationList.contains(where: { ( _ comumSubscriber : CommonDataSubscriber) -> Bool in
                return comumSubscriber.0 == subscriber.0
            })){
                // is already in the subcstiption list
                return
            }else{
                commonDataNotificationList[cacheID]?.append(subscriber)
            }
        }else{
            commonDataNotificationList[cacheID] = [subscriber]
        }
    }
    
    func unsubcribe(cacheID : String, subscriberID: String){
        commonDataNotificationList[cacheID]?.removeAll(where: { ( _ comumSubscriber : CommonDataSubscriber) -> Bool in
            return comumSubscriber.0 == subscriberID
        })
    }
    
    func saveToCacheAndNotify(cacheID: String, model: CommonDataBaseModel){
        commonDataCache[cacheID] = model
        notifyChanges(cacheID: cacheID)
    }
    
    func saveToCache(cacheID: String, model: CommonDataBaseModel){
        commonDataCache[cacheID] = model
    }
    
    func returnFromCache(cacheID: String) -> CommonDataBaseModel?{
        return commonDataCache[cacheID]
    }
    
    func removeFromCache(cacheID: String){
        commonDataCache.removeValue(forKey: cacheID)
        notifyChanges(cacheID: cacheID)
    }
    
}

