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
    
    typealias UploadImageComplition = (Result<String, StorageErrors>) -> Void
    public func uploadImage(with data: Data, fileName: String, completion: @escaping UploadImageComplition) {
        
        storage.child("images/" + fileName).putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard let self = self else {return}
            
            guard error == nil else {
                completion(.failure(.failedToUpload))
                return
            }
            
            self.storage.child("images/" + fileName).downloadURL(completion: { url, error in
                guard let url = url else {
                    completion(.failure(.failedToUpload))
                    return
                }
                let urlString = url.absoluteString
                completion(.success(urlString))
            })
        })
    }
    
    public func getDownloadURL(for path: String, competion: @escaping (String) -> Void) {
        
        let reference = storage.child(path)
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                competion("")
                return
            }
            
            competion(url.absoluteString)
            
        })
    }
    
}
