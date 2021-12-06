//
//  HomeView.swift
//  Rave
//
//  Created by Bernie Cartin on 6/17/21.
//

import SwiftUI

struct HomeView: View {
    // MARK: PROPERTIES
    @EnvironmentObject var session: SessionManager
    @ObservedObject var postManager: PostManager
    @ObservedObject var commentsManager: CommentsManager
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                Image("rave-logo-text")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 30, alignment: .center)
                
                LazyVStack(spacing: 0) {
                    ForEach(postManager.posts) { post in
                        if session.user.blocked?.firstIndex(of: post.createdBy ?? "") == nil {
                            PostView(postManager: postManager, commentsManager: commentsManager, post: post)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(postManager: PostManager(), commentsManager: CommentsManager())
            .environmentObject(SessionManager())
    }
}
