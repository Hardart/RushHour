//
//  StorageManager.swift
//  RushHour
//
//  Created by Артем Шакиров on 23.11.2021.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public func uploadImage(with data: Data, fileName: String, completion: @escaping (Result<String, Error>) -> Void){
        storage.child("images/" + fileName).putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard let self = self else {return}
            guard error == nil else {
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/" + fileName).downloadURL(completion: {url, error in
                guard let url = url else {
                    completion(.failure(StorageErrors.failedToDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                completion(.success(urlString))
            })
        })
    }
    
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToDownloadURL
    }
    
    
}
