//
//  SinglePostView.swift
//  Rave
//
//  Created by Bernie Cartin on 8/2/21.
//

import SwiftUI

struct SinglePostView: View {
    // MARK: PROPERTIES
    @EnvironmentObject var session: SessionManager
    @ObservedObject var postManager: PostManager
    @ObservedObject var commentsManager: CommentsManager
    
    @State var post: Post?
    var postID: String?
    
    // MARK: BODY
    var body: some View {
        VStack {
            if let post = post {
                ShortPostView(post: post)
            }
            else {
                Text(post?.id ?? "")
            }
            List(commentsManager.comments) { comment in
                CommentCellView(comment: comment)
            }
            Spacer()
        }
        .onAppear(perform: {
            commentsManager.fetchComments(postId: postID ?? "")
            self.post = postManager.myPosts.first(where: { post in
                post.id == postID
            })
        })
    }
}

struct SinglePostView_Previews: PreviewProvider {
    static var previews: some View {
        SinglePostView(postManager: PostManager(), commentsManager: CommentsManager())
            .environmentObject(SessionManager())
    }
}
