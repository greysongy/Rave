//
//  ShortPostView.swift
//  Rave
//
//  Created by Bernie Cartin on 7/26/21.
//

import SwiftUI

struct ShortPostView: View {
    // MARK: PROPERTIES
    var post: Post
    
    // MARK: BODY
    var body: some View {
        VStack {
            HStack {
                VStack(alignment:.leading, spacing: 4) {
                    Text(post.topic ?? "")
                        .font(.system(size: 15, weight: .semibold))
                    Text(post.comments ?? "")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.leading)
                }
                .padding(.leading, 12)
                
                Spacer()
                
                Image(systemName: "star.fill")
                    .foregroundColor(Color("BlueMedium"))
                Text("\(post.review ?? 0)")
                    .foregroundColor(Color("BlueMedium"))
                    .padding(.trailing, 12)
                
            }
            .padding(.top, 8)
            Divider()
                .padding(.bottom, 0)
        }
        .navigationBarTitle("Comments", displayMode: .inline)
    }
}

struct ShortPostView_Previews: PreviewProvider {
    static var previews: some View {
        ShortPostView(post: Post())
            .previewLayout(.sizeThatFits)
    }
}
