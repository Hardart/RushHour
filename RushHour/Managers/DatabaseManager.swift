//
//  DatabaseManager.swift
//  RushHour
//
//  Created by Артем Шакиров on 17.11.2021.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database(url: "https://chat-app-ios-a7b3a-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    static func safeEmail(_ email: String) -> String {
        let safeEmail = email.replacingOccurrences(of: ".", with: "-")
        return safeEmail
    }
    
}

//MARK: -Account managment
extension DatabaseManager {
    public func doesUserExist(with email: String,
                              completion: @escaping((Bool) -> Void)) {
        
        let safeEmail = email.replacingOccurrences(of: ".", with: "-")
        database.child("users/" + safeEmail).observeSingleEvent(of: .value, with: {DataSnapshot in
            guard DataSnapshot.value as? [String: String] != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    /// Добавление нового пользователя в базу
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void){
        database.child("users").child(user.safeEmail).setValue([
            "nick_name": user.nickname,
            "first_name": user.firstName,
            "last_name": user.lastName
        ], withCompletionBlock: {error, _ in
            guard error == nil else {
                print("withCompletionBlock error")
                completion(false)
                return
            }
            completion(true)
        })
    }
}


struct ChatAppUser {
    let nickname: String
    let firstName: String
    let lastName: String
    let email: String
    
    var safeEmail: String {
        DatabaseManager.safeEmail(email)
    }
    
    var profileImageFileName: String {
        return "\(safeEmail)_profile_image.png"
    }
}
