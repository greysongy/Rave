//
//  StartView.swift
//  Rave
//
//  Created by Bernie Cartin on 6/17/21.
//

import SwiftUI

struct StartView: View {
    @State private var isSigninUp = false
    
    var body: some View {
        if isSigninUp {
            SignUpView(isSigningUp: $isSigninUp)
        }
        else {
            LoginView(isSigningUp: $isSigninUp)
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
