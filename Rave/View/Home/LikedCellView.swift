//
//  LikedCellView.swift
//  Rave
//
//  Created by Bernie Cartin on 7/26/21.
//

import SwiftUI
import Kingfisher

struct LikedCellView: View {
    // MARK: PROPERTIES
    @EnvironmentObject var session: SessionManager
    @ObservedObject var commentsManager: CommentsManager
    
    var uid: String
    
    @State var user: QuickUser?
    
    // MARK: BODY
    var body: some View {
        HStack {
            NavigationLink(
                destination: PersonProfile(postManager: PostManager(), commentsManager: commentsManager, userID: user?.id ?? ""),
                label: {
                    KFImage(URL(string: user?.profileImageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48, alignment: .center)
                        .clipShape(Circle())
                        .padding(.leading, 12)
                })
            
            Text(user?.username ?? (user?.name ?? ""))
            
            Spacer()
            
            Button(action: {
                updateFollowingStatus()
            }, label: {
                Text(isFollowing() ? "Following" : "Follow")
                    .font(.footnote)
                    .foregroundColor(isFollowing() ? .black : .white)
                    .frame(width: 100, height: 36, alignment: .center)
                    .background(isFollowing() ? Color.white : Color("BlueMedium"))
                    .border(Color.blue, width: 1)
                    .padding(.trailing, 12)
            })
        }
        .onAppear {
            UserManager().fetchQuickUser(uid: uid) { user in
                self.user = user
            }
        }
    }
    
    func isFollowing() -> Bool {
        guard let following = session.user.following else {return false}
        return following.contains(user?.id ?? "")
    }
    
    func updateFollowingStatus() {
        let userManager = UserManager()
        guard let followingId = user?.id else {return}
        let followerId = session.user.id
        if isFollowing() {
            userManager.removeFollower(followingId: followingId, followerId: followerId)
        }
        else {
            userManager.addFollower(followingId: followingId, followerId: followerId)
            saveNotification()
        }
    }
    
    func saveNotification() {
        if let uid = user?.id {
            let notification = AppNotification(type: NotificationType.Follow.rawValue, submittedBy: session.user.id, date: Date(), submitterName: session.user.name)
            NotificationsManager().saveNotification(uid: uid, notification: notification)
        }
    }
}

struct LikedCellView_Previews: PreviewProvider {
    static var previews: some View {
        LikedCellView(commentsManager: CommentsManager(), uid: "sd")
            .previewLayout(.sizeThatFits)
            .environmentObject(SessionManager())
    }
}
