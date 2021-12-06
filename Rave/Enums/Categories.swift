//
//  Categories.swift
//  Rave
//
//  Created by Bernie Cartin on 7/25/21.
//

import Foundation

enum Categories: String {
    
    case Entertainment = "Entertainment"
    case Music = "Music"
    case Event = "Event"
    case Place = "Place"
    case Food = "Food"
    
    func imageName() -> String {
        switch self {
        
        case .Entertainment:
            return "entertainment"
        case .Music:
            return "music"
        case .Event:
            return "event"
        case .Place:
            return "place"
        case .Food:
            return "food"
        }
    }
    
}
