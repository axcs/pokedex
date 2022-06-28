//
//  BaseResponse.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

import Foundation

enum BaseResponse<T>{
    case success(T?)
    case failure(ErrorType)
}
