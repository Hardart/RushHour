//
//  UserDefaults.swift
//  RushHour
//
//  Created by Артем Шакиров on 24.12.2021.
//

import UIKit

final class UserDataCache {
    
    static let shared = UserDataCache()
    
    public func getUserData() -> UserData? {
        guard let getData = UserDefaults.standard.value(forKey: "userData") as? NSDictionary else { return nil}
        return try? getData.toUserData()
    }
    
    public func saveUIDToUserData(uid: String, url: String) {
        let data = try? UserData(uid: uid, imageURL: url).asDictionary()
        UserDefaults.standard.set(data, forKey: "userData")
    }
    
    public func setupHeaderView(urlString: String, view: UIView) -> UIView? {
        
        let header = ConfigHeaderView(frame: CGRect(x: 0, y: 0, width: view.width, height: 140))
        DispatchQueue.main.async {
            if let url = URL(string: urlString) {
                header.configureWithURL(imageURL: url)
            } else {
                header.configureWithImage(image: UIImage(systemName: "person.circle.fill")!)
            }
        }
        return header
    }
    
}
