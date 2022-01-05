//
//  StructToString.swift
//  RushHour
//
//  Created by Артем Шакиров on 16.12.2021.
//

import Foundation

extension Encodable {
    
    func asDictionary() throws -> [String: Any] {
        
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    func asArray() throws -> [Any] {
        
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] else {
            throw NSError()
        }
        return dictionary
    }
}
