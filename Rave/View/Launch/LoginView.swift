//
//  LoginView.swift
//  Rave
//
//  Created by Bernie Cartin on 6/17/21.
//

import SwiftUI

struct LoginView: View {
    // MARK: PROPERTIES
    @EnvironmentObject var session: SessionManager
    
    @State private var email = ""
    @State private var password = ""
    
    @Binding var isSigningUp: Bool
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 12) {
            
            Image("rave-logo-full")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250, alignment: .center)
            
            Group {
                TextField("Email", text: $email)
                    .padding(12)
                    .background(
                        Color(.black).opacity(0.1)
                    )
                    .padding(.horizontal, 24)
                
                SecureField("Password", text: $password)
                    .padding(12)
                    .background(
                        Color(.black).opacity(0.1)
                    )
                    .padding(.horizontal, 24)
                
                Button(action: {
                    session.signIn(with: email, password: password) { _ in
                        setupPushNotifications()
                    }
                }, label: {
                    Text("LOG IN")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .shadow(radius: 3)
                        .padding(.vertical)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color("BlueLight"), Color("BlueMedium")]), startPoint: .top, endPoint: .bottom))
                                .shadow(color: .black.opacity(0.5), radius: 6, x: 0, y: 6)
                        )
                        .padding(.horizontal, 24)
                })
                .padding(.bottom, 64)
            }
            
            
            Group {
                Text("Don't have an account?".uppercased())
                    .font(.system(size: 12))
                
                Button(action: {
                    isSigningUp.toggle()
                }, label: {
                    Text("SIGN UP")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .shadow(radius: 3)
                        .padding(.vertical)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color("BlueLight"), Color("BlueMedium")]), startPoint: .top, endPoint: .bottom))
                                .shadow(color: .black.opacity(0.5), radius: 6, x: 0, y: 6)
                        )
                        .padding(.horizontal, 24)
                })
                .padding(.bottom, 64)
            }
            
        }
    }
    
    func setupPushNotifications() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.configuteNotifications()
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var isSigningUp: Bool = false
    static var previews: some View {
        LoginView(isSigningUp: $isSigningUp)
            .environmentObject(SessionManager())
    }
}
