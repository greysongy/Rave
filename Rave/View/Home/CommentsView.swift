//
//  CommentsView.swift
//  Rave
//
//  Created by Bernie Cartin on 7/26/21.
//

import SwiftUI
import AlertToast

struct CommentsView: View {
    // MARK: PROPERTIES
    @EnvironmentObject var session: SessionManager
    @ObservedObject var postManager: PostManager
    @ObservedObject var commentsManager: CommentsManager
    
    var post: Post
    
        
    @State private var typingMessage = ""
    
    @State var showAlert = false
    
    var alert = AlertToast(displayMode: .alert, type: .regular, title: "POSTED")

    
    // MARK: BODY
    var body: some View {
        VStack {
            ShortPostView(post: post)
//            ScrollView {
//                ForEach(commentsManager.comments) { comment in
//                    CommentCellView(comment: comment)
//                        .padding(.horizontal, 8)
//                }
//            }
            
            
            HStack {
                TextField("Comment...", text: $typingMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: CGFloat(30))
                Button(action: {
                    let comment = typingMessage
                    postComment()
                    saveNotification(comment: comment)
                }) {
                    Text("Post")
                        .foregroundColor(Color("BlueMedium"))
                        .fontWeight(.semibold)
                }
            }.frame(minHeight: CGFloat(30)).padding()
        }
        .onAppear{
            commentsManager.fetchComments(postId: self.post.id ?? "")
        }
        .toast(isPresenting: $showAlert, alert: {
            self.alert
        })
    }
    
    func postComment() {
        if let postId = self.post.id {
            let uid = session.user.id
            let comment = Comment(postId: postId, submittedBy: uid, date: Date(), comment: typingMessage)
            commentsManager.saveComment(postId: postId, comment: comment)
            typingMessage = ""
            self.showAlert.toggle()
            postManager.updatePostNumberOfComments(post: self.post)
        }
    }
    
    func saveNotification(comment: String) {
        if let uid = self.post.createdBy {
            let notification = AppNotification(type: NotificationType.Comment.rawValue, submittedBy: session.user.id, date: Date(), postId: self.post.id, comment: comment, submitterName: session.user.name)
            NotificationsManager().saveNotification(uid: uid, notification: notification)
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(postManager: PostManager(), commentsManager: CommentsManager(), post: Post())
            .environmentObject(SessionManager())
    }
}
