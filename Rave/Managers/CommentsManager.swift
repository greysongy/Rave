//
//  CommentsManager.swift
//  Rave
//
//  Created by Bernie Cartin on 7/26/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class CommentsManager: ObservableObject {
    
    let db = Firestore.firestore()
    
    var commentsListener: ListenerRegistration?
    
    @Published var comments: [Comment]
    
    init() {
        self.comments = [Comment]()
    }
    
    func fetchComments(postId: String) {
        commentsListener = db.collection(C_POSTS).document(postId).collection(C_COMMENTS).addSnapshotListener { snapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else {
                print("No Comments")
                return
            }
            
            var comments = documents.compactMap({ (queryDocumentSnapshot) -> Comment? in
                return try? queryDocumentSnapshot.data(as: Comment.self)
            })
            
            comments.sort{$0.date ?? Date() > $1.date ?? Date()}
            
            self.comments = comments
        }
    }
    
    func saveComment(postId: String, comment: Comment) {
        do {
        try _ = db.collection(C_POSTS).document(postId).collection(C_COMMENTS).addDocument(from: comment)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
