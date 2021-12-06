//
//  LikesView.swift
//  Rave
//
//  Created by Bernie Cartin on 7/26/21.
//

import SwiftUI

struct LikesView: View {
    // MARK: PROPERTIES
    @ObservedObject var commentsManager: CommentsManager
    
    var post: Post
    
    // MARK: BODY
    var body: some View {
        
        ScrollView {
            ForEach(post.likes ?? [], id: \.self) { uid in
                LikedCellView(commentsManager: commentsManager, uid: uid)
            }
        }
        .padding(.top, 4)
        .navigationBarTitle("Likes", displayMode: .inline)
        
    }
}

struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView(commentsManager: CommentsManager(), post: Post(id: "12"))
    }
}
