//
//  DynamicType.swift
//  Pokedex
//
//  Created by axavierc on 12/07/2022.
//

public struct DynamicType<T> {
    typealias ModelEventListener = (T)->Void
    typealias Listeners = [ModelEventListener]
    
    private var listeners:Listeners = []
    var value:T? {
        didSet {
            for (_,observer) in listeners.enumerated() {
                if let value = value {
                    observer(value)
                }
            }
            
        }
    }
    
    
    mutating func bind(_ listener:@escaping ModelEventListener) {
        listeners.append(listener)
        if let value = value {
            listener(value)
        }
    }
    
}
