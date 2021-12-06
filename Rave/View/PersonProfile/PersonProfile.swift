//
//  PersonProfile.swift
//  Rave
//
//  Created by Bernie Cartin on 7/28/21.
//

import SwiftUI
import Kingfisher
import AlertToast

struct PersonProfile: View {
    // MARK: PROPERTIES
    @EnvironmentObject var session: SessionManager
    @ObservedObject var postManager: PostManager
    @ObservedObject var commentsManager: CommentsManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var user: User?
    
    @State var posts: [Post]?
    
    @State var showOptionsSheet = false
    @State var showReport = false
    @State var showAlert = false
    
    var alert = AlertToast(displayMode: .alert, type: .regular, title: "REPORT SUBMITTED")
    
    var userID: String
    
    // MARK: BODY
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left.circle")
                            .font(.title2)
                            .foregroundColor(.gray)
                    })
                    Spacer()
                    Button(action: {
                        self.showOptionsSheet.toggle()
                    }, label: {
                        Image(systemName: "exclamationmark.circle")
                            .font(.title2)
                            .foregroundColor(.gray)
                    })
                }
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    if let urlString = user?.profileImageUrl {
                        KFImage(URL(string: urlString))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 100, height: 100, alignment: .center)
                    }
                    else {
                        Image("default")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 100, height: 100, alignment: .center)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(user?.name ?? "")
                            .font(.title2)
                            .fontWeight(.medium)
                        Text(user?.username ?? "")
                            .font(.footnote)
                            .fontWeight(.light)
                            .foregroundColor(Color(white: 0, opacity: 0.5))
                        Text(user?.bio ?? "")
                            .font(.system(size: 13))
                            .multilineTextAlignment(.leading)
                        
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                HStack{
                    
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
                    
                    Spacer()
                    
                    VStack {
                        Text("\(user?.numberOfPosts ?? 0)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text("Posts")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 48)
                    .border(Color.gray)
                    
                    NavigationLink(
                        destination: FollowingView(commentsManager: commentsManager ,user: self.user),
                        label: {
                            VStack {
                                Text("\(user?.following?.count ?? 0)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Text("Following")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 48)
                            .border(Color.gray)
                        })
                    
                    NavigationLink(
                        destination: FollowersView(commentsManager: commentsManager ,user: self.user),
                        label: {
                            VStack {
                                Text("\(user?.followers?.count ?? 0)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Text("Followers")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 48)
                            .border(Color.gray)
                        })
                    
                }
                .padding(.horizontal, 24)
                
                Divider()
                    .padding(.top)
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(posts ?? []) { post in
                            PostView(postManager: postManager, commentsManager: commentsManager, post: post)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear{
                UserManager().fetchUserOnce(uid: userID) { result in
                    switch result {
                    
                    case .success(let user):
                        self.user = user
                        postManager.fetchUserPosts(for: user.id) { posts in
                            self.posts = posts
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            .actionSheet(isPresented: $showOptionsSheet) {
                ActionSheet(title: Text("User Options"), message: nil, buttons: [
                    .default(Text("Report user")) {
                        self.showReport.toggle()
                    },
                    .default(Text("Block User")) {
                        if let uid = user?.id {
                            if ((session.user.blocked?.append(uid)) == nil) {
                                session.user.blocked = [uid]
                            }
                            UserManager().saveUserData(user: session.user)
                        }
                    },
                    .cancel()
                ])
            }
            .toast(isPresenting: $showAlert, alert: {
                self.alert
            })
            //: END VSTACK
            
            ReportView(showReport: $showReport, showAlert: $showAlert, user: user)
        } //: END ZSTACK
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
            if let index = user?.followers?.firstIndex(of: followerId) {
                user?.followers?.remove(at: index)
            }
        }
        else {
            userManager.addFollower(followingId: followingId, followerId: followerId)
            if (user?.followers?.append(followerId)) != nil {
                user?.followers = [followerId]
            }
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

struct PersonProfile_Previews: PreviewProvider {
    static var previews: some View {
        PersonProfile(postManager: PostManager(), commentsManager: CommentsManager(), userID: "")
            .environmentObject(SessionManager())
    }
}
