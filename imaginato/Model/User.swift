//
//  User.swift
//  imaginato
//
//  Created by rlogical-dev-35 on 14/12/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.

import Foundation
import RealmSwift

// MARK: - User

@objcMembers
class User: Object,Codable {
    
    @objc dynamic var userID: Int
    @objc dynamic var userName: String
    @objc dynamic var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userName
        case createdAt = "created_at"
    }
}

// MARK: - Response

class LoginResponse: Codable {
    let result: Int
    let errorMessage: String
    let data: DataClass
    
    enum CodingKeys: String, CodingKey {
        case result
        case errorMessage = "error_message"
        case data
    }
}

// MARK: - DataClass

class DataClass: Codable {
    let user: User?
}
