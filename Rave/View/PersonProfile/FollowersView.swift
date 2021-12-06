//
//  FollowersView.swift
//  Rave
//
//  Created by Bernie Cartin on 8/2/21.
//

import SwiftUI

struct FollowersView: View {
    // MARK: PROPERTIES
    @ObservedObject var commentsManager: CommentsManager
    
    var user: User?
    
    // MARK: BODY
    var body: some View {
        ScrollView {
            ForEach(user?.followers ?? [], id: \.self) { uid in
                LikedCellView(commentsManager: commentsManager, uid: uid)
            }
        }
        .padding(.top, 4)
        .navigationBarTitle("Followers", displayMode: .inline)
    }
}

struct FollowersView_Previews: PreviewProvider {
    static var previews: some View {
        FollowersView(commentsManager: CommentsManager())
    }
}
