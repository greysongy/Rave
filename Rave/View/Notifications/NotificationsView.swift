//
//  NotificationsView.swift
//  Rave
//
//  Created by Bernie Cartin on 6/17/21.
//

import SwiftUI

struct NotificationsView: View {
    // MARK: PROPERTIES
    @ObservedObject var notificationsManager: NotificationsManager
    @ObservedObject var postManager: PostManager
    @ObservedObject var commentsManager: CommentsManager
        
    // MARK: BODY
    var body: some View {
        NavigationView {
            VStack {
                Image("rave-logo-text")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 60, alignment: .center)
                
                List(notificationsManager.notifications) { notification in
                    NavigationLink(
                        destination: getDestination(for: notification),
                        label: {
                            NotificationCell(notification: notification)
                        })
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarHidden(true)
        }
    }
    
    func getDestination(for notification: AppNotification) -> AnyView {
        switch notification.typeEnum {
        
        case .Like:
            return AnyView(SinglePostView(postManager: postManager, commentsManager: commentsManager ,postID: notification.postId ?? ""))
        case .Follow:
            return AnyView(PersonProfile(postManager: postManager, commentsManager: commentsManager, userID: notification.submittedBy ?? ""))
        case .Comment:
            return AnyView(SinglePostView(postManager: postManager,  commentsManager: commentsManager ,postID: notification.postId ?? ""))
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView(notificationsManager: NotificationsManager(), postManager: PostManager(), commentsManager: CommentsManager())
    }
}
