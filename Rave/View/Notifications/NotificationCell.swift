//
//  NotificationCell.swift
//  Rave
//
//  Created by Bernie Cartin on 7/26/21.
//

import SwiftUI
import Kingfisher

struct NotificationCell: View {
    // MARK: PROPERTIES
    
    var notification: AppNotification?
    
    @State var user: QuickUser?
    
    // MARK: BODY
    
    var body: some View {
        
        HStack {
            
            KFImage(URL(string: user?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44, alignment: .center)
                .clipShape(Circle())
            
            
            if notification?.typeEnum == .Comment {
                Text("\(Text(user?.username ?? (user?.name ?? "")).foregroundColor(.blue).fontWeight(.semibold)) commented on your post: \(Text(notification?.comment ?? "").foregroundColor(.black))   \(Text(notification?.date?.timeAgoDisplay() ?? "").font(.system(size: 10)))")
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
            }
            if notification?.typeEnum == .Like {
                Text("\(Text(user?.username ?? (user?.name ?? "")).foregroundColor(.blue).fontWeight(.semibold)) liked your post \(Text(notification?.date?.timeAgoDisplay() ?? "").font(.system(size: 10)))")
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
            }
            if notification?.typeEnum == .Follow {
                Text("\(Text(user?.username ?? (user?.name ?? "")).foregroundColor(.blue).fontWeight(.semibold)) started following you \(Text(notification?.date?.timeAgoDisplay() ?? "").font(.system(size: 10)))")
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
            }
            else {
                EmptyView()
            }
        }
        .onAppear{
            UserManager().fetchQuickUser(uid: notification?.submittedBy ?? "") { user in
                self.user = user
            }
        }
    }
}

struct NotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCell()
    }
}
