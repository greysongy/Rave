//
//  PostView.swift
//  Rave
//
//  Created by Bernie Cartin on 6/17/21.
//

import SwiftUI
import Kingfisher

struct PostView: View {
    // MARK: PROPERTIES
    @EnvironmentObject var session: SessionManager
    @ObservedObject var postManager: PostManager
    @ObservedObject var commentsManager: CommentsManager
    
    var post: Post
    
//    @State var postingUser: User?
    @State var postingUser: QuickUser?
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("BlueMedium"))
                    .frame(maxWidth: .infinity, maxHeight: 30)
                HStack {
                    Spacer()
                    Image(Categories(rawValue: post.category ?? "")?.imageName() ?? "")
                        .resizable()
                        .colorInvert()
                        .scaledToFill()
                        .frame(width: 20, height: 20, alignment: .center)
                        .padding(.trailing, 12)
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(Color("BlueMedium"), width: 1)
                    
                VStack {
                    HStack {
                        Spacer()
                        Text(post.date?.stringValue(format: "MMM dd, yyyy") ?? "")
                            .font(.caption)
                            .padding(8)
                    }
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        NavigationLink(
                            destination: PersonProfile(postManager: postManager, commentsManager: commentsManager, userID: postingUser?.id ?? ""),
                            label: {
                                KFImage(URL(string: postingUser?.profileImageUrl ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44, alignment: .center)
                                    .clipShape(Circle())
                                    .padding(.leading)
                                    .padding(.top, 8)
                            })
                        
                        
                        VStack(alignment: .leading) {
                            Text((postingUser?.username ?? (postingUser?.name ?? "")) + " is reviewing")
                                .font(.system(size: 12))
                                .padding(.top, 8)
                                .padding(.bottom, 1)
                            
                            Text(post.topic ?? "")
                                .fontWeight(.heavy)
                                .font(.system(size: 14))
                                .padding(.bottom, 4)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Spacer()
                        
                        
                    }
                    
                    //                    RatingView(rating: post.review ?? 0)
                    //                        .padding(.bottom, 4)
                    
                    HStack {
                        Spacer()
                        RatingSlider(rating: post.review ?? 0, width: 0)
                        
                        Text(Rating(rawValue: post.review!)?.stringValue() ?? "")
                            .fontWeight(.bold)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 4)
                            .foregroundColor(.white)
                            .background(Color("BlueMedium"))
                            .padding(.leading)
                        
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    
                    Text(post.comments ?? "")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(9)
                        .padding(.horizontal, 12)
                        .frame(alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let imageUrl = post.imageUrl {
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: 300)
                            .clipped()
                            .padding(.horizontal, 1)
                    }
                    
                    HStack{
                        Button(action: {
                            postManager.updatePostLikeStatus(uid: session.user.id, name: session.user.name, post: post)
                        }, label: {
                            post.likes?.firstIndex(of: session.user.id) != nil ?  Image(systemName: "heart.fill") : Image(systemName: "heart")
                        })
                            .foregroundColor(Color("BlueMedium"))
                        
                        if let count = post.likes?.count, count > 0 {
                            NavigationLink(
                                destination: LikesView(commentsManager: commentsManager, post: self.post),
                                label: {
                                    Text("\(count)")
                                        .foregroundColor(Color("BlueMedium"))
                                        .font(.footnote)
                                })
                        }
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: CommentsView(postManager: self.postManager, commentsManager: commentsManager, post: self.post),
                            label: {
                                if let count = post.numberOfComments, count > 0 {
                                    Text("\(count)")
                                        .foregroundColor(Color("BlueMedium"))
                                        .font(.footnote)
                                }
                                
                                Image(systemName: "bubble.left")
                            })
                    }
                    .padding(.horizontal)
                    .padding(.top, 1)
                    .padding(.bottom, 8)
                }
            }
            
        } //: END VSTACK
        .padding(.horizontal, 8)
        .padding(.vertical)
        .onAppear(perform: {
            UserManager().fetchQuickUser(uid: post.createdBy ?? "") { user in
                self.postingUser = user
            }
        })
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(postManager: PostManager(), commentsManager: CommentsManager(), post: Post(id: "asd"))
            .previewLayout(.sizeThatFits)
            .environmentObject(SessionManager())
    }
}
