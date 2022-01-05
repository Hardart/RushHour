//
//  UserDefaults.swift
//  RushHour
//
//  Created by Артем Шакиров on 24.12.2021.
//

import Foundation

final class StorageManager {
    
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    
    
}
