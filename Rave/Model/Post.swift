//
//  Post.swift
//  Rave
//
//  Created by Bernie Cartin on 6/18/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var topic: String?
    var imageUrl: String?
    var category: String?
    var review: Int?
    var comments: String?
    var createdBy: String?
    var date: Date?
    var likes: [String]?
    var numberOfComments: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case topic
        case imageUrl
        case category
        case review
        case comments
        case createdBy
        case date
        case likes
        case numberOfComments
    }
    
}
