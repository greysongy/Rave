//
//  Notification.swift
//  Rave
//
//  Created by Bernie Cartin on 7/26/21.
//

import Foundation
import FirebaseFirestoreSwift

struct AppNotification: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var type: String?
    var submittedBy: String?
    var date: Date?
    var postId: String?
    var comment: String?
    var submitterName: String?
    
    var typeEnum: NotificationType {
        NotificationType(rawValue: self.type ?? "") ?? .Comment
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case submittedBy
        case date
        case postId
        case comment
        case submitterName
    }
}
