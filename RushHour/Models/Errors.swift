//
//  Errors.swift
//  RushHour
//
//  Created by Артем Шакиров on 13.12.2021.
//

import Foundation


public enum StorageErrors: Error {
    case failedToUpload
    case failedToDownloadURL
}

public enum DatabaseErrors: Error {
    case failedToFetch
    case failesToDecode
    case pathDoesNotExist
}
