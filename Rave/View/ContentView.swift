//
//  ContentView.swift
//  Rave
//
//  Created by Bernie Cartin on 6/17/21.
//

import SwiftUI

struct ContentView: View {
    // MARK: PROPERTIES
    
    @EnvironmentObject var session : SessionManager
    
    // MARK: BODY
    var body: some View {
        ZStack {
            if (session.session != nil) {
                TabsView()
            }
            else {
                StartView()
            }
            
            if session.showActivityIndicatorView {
                ActivityIndicatorView()
            }
        } //: END ZSTACK
        .onAppear(perform: {
            checkSessionStatus()
        })
    }
    
    // MARK: FUNCTIONS
    
    func checkSessionStatus() {
        session.listen()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionManager())
    }
}
