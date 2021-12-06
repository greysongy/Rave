//
//  Comment.swift
//  Rave
//
//  Created by Bernie Cartin on 7/26/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var postId: String?
    var submittedBy: String?
    var date: Date?
    var comment: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postId
        case submittedBy
        case date
        case comment
    }
}
