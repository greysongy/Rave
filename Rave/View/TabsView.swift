//
//  TabsView.swift
//  Rave
//
//  Created by Bernie Cartin on 6/17/21.
//

import SwiftUI

struct TabsView: View {
    @StateObject var postManager = PostManager()
    @StateObject var notificationsManager = NotificationsManager()
    @StateObject var commentsManager = CommentsManager()
    @State private var selection = 0
    
    @AppStorage(C_SHOWTUTORIAL) private var showTutorial = true
    
    var body: some View {
        ZStack {
            
            
            TabView(selection: $selection) {
                HomeView(postManager: postManager, commentsManager: commentsManager)
                    .tabItem {
                        Image(systemName: "house.fill")
                    }
                    .tag(0)
                
                AddPostView()
                    .tabItem {
                        Image(systemName: "star.fill")
                    }
                    .tag(1)
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }
                    .tag(2)
                
                NotificationsView(notificationsManager: notificationsManager, postManager: postManager, commentsManager: commentsManager)
                    .tabItem {
                        Image(systemName: "bell.fill")
                    }
                    .tag(3)
                
                ProfileView(postManager: postManager, commentsManager: commentsManager)
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                    }
                    .tag(4)
            }
            .accentColor(Color("BlueMedium"))
            
            if showTutorial {
                TutorialView()
            }
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
            .environmentObject(SessionManager())
    }
}
