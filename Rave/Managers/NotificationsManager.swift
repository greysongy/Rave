//
//  NotificationsManager.swift
//  Rave
//
//  Created by Bernie Cartin on 7/26/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class NotificationsManager: ObservableObject {
    
    let db = Firestore.firestore()
    
    var notificationsListener: ListenerRegistration?
    
    
    @Published var notifications: [AppNotification]
    
    init() {
        self.notifications = [AppNotification]()
        self.fetchNotifications()
    }
    
    func fetchNotifications() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        notificationsListener = db.collection(C_USERS).document(uid).collection(C_NOTIFICATIONS).addSnapshotListener({ querySnapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No Notifications")
                return
            }
            
            var notifications = documents.compactMap({ (queryDocumentSnapshot) -> AppNotification? in
                return try? queryDocumentSnapshot.data(as: AppNotification.self)
            })
            
            notifications.sort{$0.date ?? Date() > $1.date ?? Date()}
            
            self.notifications = notifications
        })
    }
    
    func saveNotification(uid: String, notification: AppNotification) {
        do {
        try _ = db.collection(C_USERS).document(uid).collection(C_NOTIFICATIONS).addDocument(from: notification)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
