//
//  SessionManager.swift
//  Rave
//
//  Created by Bernie Cartin on 6/18/21.
//

import SwiftUI
import Firebase
import Combine

class SessionManager: ObservableObject {
    
    var didChange = PassthroughSubject<SessionManager,Never>()

    let uid = Auth.auth().currentUser?.uid ?? "uid"
    
    @Published var user: User = User(id: "", name: "", email: "")
    
    @Published var session : String? {
        didSet {
            self.didChange.send(self)
        }
    }
    
    @Published var showActivityIndicatorView = false
    
    var handle : AuthStateDidChangeListenerHandle?
    
    func listen(){
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                print("user state changed")
                self.session = user.uid
                UserManager().fetchUser(uid: user.uid) { result in
                    switch result {
                    case .success(let dbUser):
                        self.user = dbUser
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            } else {
                self.session = nil
            }
        })
    }
    
    func signIn(with email: String, password: String, completion: @escaping (Result<String,Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let err = error {
                completion(.failure(err))
            }
            guard let user = result?.user else {
                completion(.failure(error!))
                return
            }
            UserManager().fetchUser(uid: user.uid) { result in
                switch result {
                
                case .success(let dbUser):
                    self.user = dbUser
                    completion(.success(user.uid))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func changePassword(oldpassword: String, newPassword: String, completion: @escaping (Result<String,Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {return}
        Auth.auth().signIn(withEmail: email, password: oldpassword) { result, error in
            if let err = error {
                completion(.failure(err))
            }
            guard let user = result?.user else {
                completion(.failure(error!))
                return
            }
            
            Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { error in
                if let err = error {
                    completion(.failure(err))
                }
                else {
                    completion(.success(user.uid))
                }
            })
        }
    }
    
    func signUp(with email: String, password: String, completion: @escaping (Result<String,Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let err = error {
                completion(.failure(err))
            }
            guard let user = result?.user else {
                completion(.failure(error!))
                return
            }
            self.user = User(id: user.uid, name: "", email: email)
            completion(.success(user.uid))
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            self.session = nil
        } catch {
            print("Error signing out", error.localizedDescription)
        }
    }
    
    func unbind(){
        if let handle = handle {
            print("unbind")
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
    
}
