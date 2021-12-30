//
//  UserManager.swift
//  Rave
//
//  Created by Bernie Cartin on 6/18/21.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class UserManager {
    
    let db = Firestore.firestore()
    
    var userListener: ListenerRegistration?
    
    func saveUserData(user: User?) {
        if let uid = user?.id {
            do {
                _ = try db.collection(C_USERS).document(uid).setData(from: user, merge: true)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveUserData(user: User?, completion: @escaping(Result<String, Error>) -> ()) {
        if let uid = user?.id {
            do {
                _ = try db.collection(C_USERS).document(uid).setData(from: user, merge: true)
                completion(.success("Saved"))
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func saveUserData(uid: String, data: [String:Any], completion: @escaping(Result<String, Error>) -> ()) {
        db.collection(C_USERS).document(uid).setData(data, merge: true) { error in
            if let err = error {
                completion(.failure(err))
            }
            else {
                completion(.success(uid))
            }
        }
    }

    
    func fetchUser(uid: String, completion: @escaping(Result<User, Error>) -> ()) {
        userListener = db.collection(C_USERS).document(uid).addSnapshotListener({ snapshot, error in
            if let err = error {
                print(err.localizedDescription)
                completion(.failure(err))
                return
            }
            do {
                if let user = try snapshot?.data(as: User.self) {
                    completion(.success(user))
                }
            }
            catch {
                completion(.failure(error))
            }
        })
    }
    
    func fetchAllUsers(completion: @escaping(Result<[User], Error>) -> ()) {
        var userList: [User] = []
        db.collection(C_USERS).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(.failure(err))
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    do {
                        if let user = try document.data(as: User.self) {
                            print("User should be appended to list")
                            userList.append(user)
                    }
                    }
                    catch {
                        print("Error parsing user")
                    }
                }
                completion(.success(userList))
            }
        }
    }
    
//    func callFetchAll() -> [User] {
//        print("")
//        var userList: [User] = [];
//        UserManager().fetchAllUsers() { result in
//            switch result {
//            case .success(let dbUsers):
//                userList = dbUsers
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//    }
    
    func fetchUserOnce(uid: String, completion: @escaping(Result<User, Error>) -> ()) {
        db.collection(C_USERS).document(uid).getDocument { snapshot, error in
            if let err = error {
                print(err.localizedDescription)
                completion(.failure(err))
                return
            }
            do {
                if let user = try snapshot?.data(as: User.self) {
                    completion(.success(user))
                }
            }
            catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchQuickUser(uid: String, completion: @escaping(QuickUser?) -> ()) {
        if let user = userCache.object(forKey: uid as NSString) {
            completion(user)
        }
        else {
            db.collection(C_USERS).document(uid).getDocument { snapshot, error in
                if let err = error {
                    print(err.localizedDescription)
                    completion(nil)
                    return
                }
                do {
                    if let user = try snapshot?.data(as: QuickUser.self) {
                        userCache.setObject(user, forKey: uid as NSString)
                        completion(user)
                    }
                }
                catch {
                    completion(nil)
                }
            }
        }
    }
    
    func addFollower(followingId: String, followerId: String) {
        db.collection(C_USERS).document(followerId).updateData([C_FOLLOWING: FieldValue.arrayUnion([followingId])])
        db.collection(C_USERS).document(followingId).updateData([C_FOLLOWERS: FieldValue.arrayUnion([followerId])])
    }
    
    func removeFollower(followingId: String, followerId: String) {
        db.collection(C_USERS).document(followerId).updateData([C_FOLLOWING: FieldValue.arrayRemove([followingId])])
        db.collection(C_USERS).document(followingId).updateData([C_FOLLOWERS: FieldValue.arrayRemove([followerId])])
    }
    
    func uplaodImage(_ profileImage : UIImage, completion : @escaping(Result<String, Error>) -> ()) {
        let ref = Storage.storage().reference()
        let imageName = UUID().uuidString
        let storageRef = ref.child(C_USERIMAGES).child(imageName)
        
        if let uploadData = profileImage.jpegData(compressionQuality: 0.2) {
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
    
    func deleteImage(_ photoUrl: String, completion : @escaping(Result<Bool, Error>) -> ()) {
        let ref = Storage.storage().reference(forURL: photoUrl)
        ref.delete { error in
            if let err = error {
                completion(.failure(err))
            }
            else {
                completion(.success(true))
            }
        }
    }
    
    func loadImage(_ imageUrl: String, completion : @escaping(Result<UIImage, Error>) -> ()) {
        let imageRef = Storage.storage().reference(forURL: imageUrl)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
            }
            else {
                let image = UIImage(data: data!)
                completion(.success(image!))
            }
        }
    }
    
    
}
