//
//  User.swift
//  Rave
//
//  Created by Bernie Cartin on 6/18/21.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable, Hashable {
    var id: String 
    var name: String
    var username: String = ""
    var profileImageUrl: String?
    var email: String
    var bio: String = ""
    var following: [String]?
    var followers: [String]?
    var numberOfPosts: Int?
    var blocked: [String]?
    var badgeCount: Int?
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case profileImageUrl
        case email
        case bio
        case following
        case followers
        case numberOfPosts
        case blocked
        case badgeCount
        case token
    }
    
}
