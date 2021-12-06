//
//  ProfileView.swift
//  Rave
//
//  Created by Bernie Cartin on 6/17/21.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    // MARK: PROPERTIES
    @EnvironmentObject var session: SessionManager
    @ObservedObject var postManager: PostManager
    @ObservedObject var commentsManager: CommentsManager
    
    @State var showEditProfile = false
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        session.signOut()
                    }, label: {
                        Text("Sign Out")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    })
                }
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    if let urlString = session.user.profileImageUrl {
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
                        Text(session.user.name)
                            .font(.title2)
                            .fontWeight(.medium)
                        Text(session.user.username)
                            .font(.footnote)
                            .fontWeight(.light)
                            .foregroundColor(Color(white: 0, opacity: 0.5))
                        Text(session.user.bio)
                            .font(.system(size: 13))
                            .multilineTextAlignment(.leading)
                        
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                HStack{
                    
                    Spacer()
                    
                    Button(action: {
                        showEditProfile.toggle()
                    }, label: {
                        Text("Edit My Profile")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 12)
                            .frame(height: 48)
                            .border(Color.gray)
                        
                    })
                    
                    NavigationLink(
                        destination: FollowingView(commentsManager: commentsManager, user: session.user),
                        label: {
                            VStack {
                                Text("\(session.user.following?.count ?? 0)")
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
                        destination: FollowersView(commentsManager: commentsManager, user: session.user),
                        label: {
                            VStack {
                                Text("\(session.user.followers?.count ?? 0)")
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
                        ForEach(postManager.myPosts) { post in
                            SelfPostView(postManager: postManager, commentsManager: commentsManager, post: post)
                        }
                    }
                }
            }
            .sheet(isPresented: $showEditProfile, content: {
                EditProfileView()
            })
            .navigationBarHidden(true)
        }
    }
    
    //MARK: FUNCTIONS
    
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(postManager: PostManager(), commentsManager: CommentsManager())
            .environmentObject(SessionManager())
    }
}
