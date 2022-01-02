//
//  SearchView.swift
//  Rave
//
//  Created by Greyson Gerhard-Young on 12/30/21.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var session: SessionManager
    @State private var users: [User] = []
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var shareControllerPresented: Bool = false
    
   

    var body: some View {

        NavigationView {
            VStack {
                // Search view
                Button(action: {
                    print("Share button clicked")
                    actionSheet()
                })
                {
                    Text("Invite a Contact")
                        .padding(10)
                        .background(Color("BlueMedium"))
                        .foregroundColor(.white)
                }
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            print("onCommit")
                        }).foregroundColor(.primary)

                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                    if showCancelButton  {
                        Button("Cancel") {
//                            UserManager().fetchAllUsers()
                                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                self.searchText = ""
                                self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(showCancelButton) // .animation(.default) // animation does not work properly

                List {
                    // Filtered list of names
//                    ForEach(array.filter{$0.hasPrefix(searchText) || searchText == ""}, id:\.self) {
//                        searchText in Text(searchText)
//                    }
                    ForEach(users.filter{$0.name.contains(searchText) || $0.username.contains(searchText) || searchText == ""}, id: \.self) {user in
                        UserRow(username: user.name, rowUserId: user.id)
                    }
                    
                    
                }
                .navigationBarTitle(Text("Discover Friends"), displayMode: .inline)
                .resignKeyboardOnDragGesture()
            }
        }
        .onAppear {
                UserManager().fetchAllUsers() { result in
                        switch result {
                        case .success(let dbUsers):
                            users = dbUsers
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
        }
    }
    
    func actionSheet() {
            guard let urlShare = URL(string: "https://raveapp.page.link/inviteFriend") else { return }
            let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
}

//TODO: Should probably refactor this into being identical with the likedcellview for following and followers
struct UserRow: View {
    var username: String
    @EnvironmentObject var session: SessionManager
//    var currentUserId: String
    var rowUserId: String
    
    var body: some View {
        HStack {
            Text(username)
            Spacer()
//            Button(action: {
//                print("I am user \(currentUserId) and I am about to follow \(rowUserId)")
//                if (currentUserId != rowUserId) {
//                    UserManager().addFollower(followingId: rowUserId, followerId: currentUserId)
//                }
//            })
//            {
//                /* To add a follower, we need the user ID of both parties. We could easily pass down the user id of this person, but how do we get the higher level user id. Needs to be passed when we create this search tab.
//                    maybe through the session manager/uid?
//
//                    Style of following button
//                 */
//                Text("Follow")
//                    .padding(10)
//                    .background(Color("BlueMedium"))
//                    .foregroundColor(.white)
//                    .cornerRadius(25)
//            }
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
    }
    
    func isFollowing() -> Bool {
        guard let following = session.user.following else {return false}
        return following.contains(rowUserId)
    }
    
    func updateFollowingStatus() {
        let userManager = UserManager()
        let followerId = session.user.id
        if isFollowing() {
            userManager.removeFollower(followingId: rowUserId, followerId: followerId)
        }
        else {
            userManager.addFollower(followingId: rowUserId, followerId: followerId)
            saveNotification()
        }
    }
    
    func saveNotification() {
        let uid = session.uid
        let notification = AppNotification(type: NotificationType.Follow.rawValue, submittedBy: session.user.id, date: Date(), submitterName: session.user.name)
        NotificationsManager().saveNotification(uid: uid, notification: notification)
        
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           ContentView()
              .environment(\.colorScheme, .light)

           ContentView()
              .environment(\.colorScheme, .dark)
        }
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
