//
//  FollowingView.swift
//  Rave
//
//  Created by Bernie Cartin on 8/2/21.
//

import SwiftUI

struct FollowingView: View {
    // MARK: PROPERTIES
    @ObservedObject var commentsManager: CommentsManager
    
    var user: User?
    
    // MARK: BODY
    var body: some View {
        ScrollView {
            ForEach(user?.following ?? [], id: \.self) { uid in
                LikedCellView(commentsManager: commentsManager, uid: uid)
            }
        }
        .padding(.top, 4)
        .navigationBarTitle("Following", displayMode: .inline)
    }
}

struct FollowingView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingView(commentsManager: CommentsManager())
    }
}
