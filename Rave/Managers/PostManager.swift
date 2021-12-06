//
//  PostManager.swift
//  Rave
//
//  Created by Bernie Cartin on 6/21/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class PostManager: ObservableObject {
    
    let db = Firestore.firestore()
    
    var postsListener: ListenerRegistration?
    
    var myPostsListener: ListenerRegistration?
    
    @Published var posts: [Post]
    @Published var myPosts: [Post]
    
    init() {
        self.posts = [Post]()
        self.myPosts = [Post]()
        self.fetchPosts()
        self.fetchMyPosts()
    }
    
    func savePost(post: Post, completion: @escaping(Result<String, Error>) -> ()) {
        do {
            _ = try db.collection(C_POSTS).document(post.id!).setData(from: post, merge: true)
            completion(.success("Saved"))
        }
        catch {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func uplaodImage(_ postImage : UIImage, completion : @escaping(Result<String, Error>) -> ()) {
        let ref = Storage.storage().reference()
        let imageName = UUID().uuidString
        let storageRef = ref.child(C_POSTIMAGES).child(imageName)
        
        if let uploadData = postImage.jpegData(compressionQuality: 0.2) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(.failure(error))
                        }
                        else {
                            if let url = url {
                                let returnData = url.absoluteString
                                completion(.success(returnData))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchPosts() {
        postsListener = db.collection(C_POSTS).addSnapshotListener({ querySnapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No Posts")
                return
            }
            
            var posts = documents.compactMap({ (queryDocumentSnapshot) -> Post? in
                return try? queryDocumentSnapshot.data(as: Post.self)
            })
            
            posts.sort{$0.date ?? Date() > $1.date ?? Date()}
            
            self.posts = posts
        })
    }
    
    func fetchMyPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let query = db.collection(C_POSTS).whereField("createdBy", isEqualTo: uid)
        myPostsListener = query.addSnapshotListener({ querySnapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No Posts")
                return
            }
            
            var posts = documents.compactMap({ (queryDocumentSnapshot) -> Post? in
                return try? queryDocumentSnapshot.data(as: Post.self)
            })
            
            posts.sort{$0.date ?? Date() > $1.date ?? Date()}
            
            self.myPosts = posts
        })
    }
    
    func updatePostLikeStatus(uid: String, name: String, post: Post) {
        var post = post
        if let index = post.likes?.firstIndex(of: uid) {
            post.likes?.remove(at: index)
        }
        else {
            if post.likes?.count ?? 0 > 0 {
                post.likes?.append(uid)
            }
            else {
                post.likes = [uid]
            }
            NotificationsManager().saveNotification(uid: post.createdBy ?? "", notification: AppNotification(type: NotificationType.Like.rawValue, submittedBy: uid, date: Date(), postId: post.id, submitterName: name))
        }
        self.savePost(post: post) { result in
            print(result)
        }
    }
    
    func updatePostNumberOfComments(post: Post) {
        var post = post
        if post.numberOfComments != nil {
            post.numberOfComments! += 1
        }
        else {
            post.numberOfComments = 1
        }
        self.savePost(post: post) { result in
            print(result)
        }
    }
    
    func fetchUserPosts(for uid: String, completion: @escaping (_ posts: [Post]) -> ()) {
        let query = db.collection(C_POSTS).whereField("createdBy", isEqualTo: uid)
        query.getDocuments(completion: { querySnapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No Posts")
                return
            }
            
            var posts = documents.compactMap({ (queryDocumentSnapshot) -> Post? in
                return try? queryDocumentSnapshot.data(as: Post.self)
            })
            
            posts.sort{$0.date ?? Date() > $1.date ?? Date()}
            
            completion(posts)
        })
    }
    
    func deletePost(post: Post, completion: @escaping (Bool) -> Void) {
        guard let postId = post.id else {
            completion(false)
            return
        }
        db.collection(C_POSTS).document(postId).delete { error in
            if let imageURl = post.imageUrl {
                let ref = Storage.storage().reference(forURL: imageURl)
                ref.delete(completion: nil)
            }
            completion(true)
        }
    }
    
}
