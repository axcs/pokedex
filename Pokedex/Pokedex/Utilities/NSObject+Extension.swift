//
//  NSObject+Extension.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//
import Foundation
import UIKit

extension NSObject {
    class var nameOfClass: String {
        return String(describing: self)
    }
}
