//
//  QuickUser.swift
//  Rave
//
//  Created by Bernie Cartin on 7/26/21.
//

import Foundation

class QuickUser: Identifiable, Codable {
    
    var id: String
    var name: String
    var username: String?
    var profileImageUrl: String?
    
    init(id: String, name: String, username: String?, profileImageUrl: String?) {
        self.id = id
        self.name = name
        self.username = username
        self.profileImageUrl = profileImageUrl
    }
    
}
