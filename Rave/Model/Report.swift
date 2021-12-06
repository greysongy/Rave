//
//  Report.swift
//  Rave
//
//  Created by Bernie Cartin on 8/2/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Report: Identifiable, Codable, Equatable {
    @DocumentID var id = UUID().uuidString
    var reportUser: String?
    var submitter: String?
    var reasons: [String]?
    var date: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case reportUser
        case submitter
        case reasons
        case date
    }
    
}
