//
//  Date.swift
//  Rave
//
//  Created by Bernie Cartin on 7/25/21.
//

import Foundation

extension Date {
    
    func stringValue(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func timeAgoDisplay() -> String {
        
        var secondsAgo = Int(Date().timeIntervalSince(self))
        
        if secondsAgo < 0 {
            secondsAgo *= -1
        }
        
        let minute = 60
        let hour = minute * 60
        let day = hour * 24
        let week = day * 7
        let month = week * 4
        
        var s = ""
        
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        }
        else if secondsAgo < hour {
            if secondsAgo / minute > 1 { s = "s"}
            return "\(secondsAgo / minute) minute\(s) ago"
        }
        else if secondsAgo < day {
            if secondsAgo / hour > 1 { s = "s"}
            return "\(secondsAgo / hour) hour\(s) ago"
        }
        else if secondsAgo < week {
            if secondsAgo / day > 1 { s = "s"}
            return "\(secondsAgo / day) day\(s) ago"
        }
        else if secondsAgo < month {
            if secondsAgo / week > 1 { s = "s"}
            return "\(secondsAgo / week) week\(s) ago"
        }
        if secondsAgo / month > 1 { s = "s"}
        return "\(secondsAgo / month) month\(s) ago"
        
    }
    
}
