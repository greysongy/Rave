//
//  SignUpView.swift
//  Rave
//
//  Created by Bernie Cartin on 6/17/21.
//

import SwiftUI

struct SignUpView: View {
    // MARK: PROPERTIES
    
    @EnvironmentObject var session: SessionManager
    
    @State private var name : String = ""
    @State private var username : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var confirmpassword : String = ""
    
    @State private var showingImagePicker = false
    @State private var inputImage : UIImage?
    @State var profileImage : Image?
    
    @State private var showingActionSheet = false
    @State private var sourceType : UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var isSigningUp: Bool
    
    @State var error : String = ""
    
    @State private var showingAlert = false
    @State var alertTitle : String = "Uh Oh 🙁"
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 12) {
            
            Image("rave-logo-text")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 60, alignment: .center)
            
            ZStack{
                if profileImage != nil {
                    profileImage!
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100, alignment: .center)
                        .padding(.top, 20)
                        .padding(.bottom,20)
                        .onTapGesture {
                            self.showingActionSheet = true
                        }
                }else {
                    Image("default")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100, alignment: .center)
                        .padding(.top, 20)
                        .padding(.bottom,20)
                        .onTapGesture {
                            self.showingActionSheet = true
                        }
                }
            }
            
            Group {
                TextField("Name", text: $name)
                    .padding(12)
                    .background(
                        Color(.black).opacity(0.1)
                    )
                    .padding(.horizontal, 24)
                
                TextField("Username", text: $username)
                    .padding(12)
                    .background(
                        Color(.black).opacity(0.1)
                    )
                    .padding(.horizontal, 24)
                
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
                
                SecureField("Confirm Password", text: $confirmpassword)
                    .padding(12)
                    .background(
                        Color(.black).opacity(0.1)
                    )
                    .padding(.horizontal, 24)
                
                Button(action: {
                    signUp()
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
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
                    }
                
               
                VStack {
                    Text("By clicking SIGN UP you agree to the ")
                    Link("Terms & Conditions and Privacy Policy", destination: URL(string: "https://www.termsfeed.com/live/a0843854-3aa0-4994-ae5e-9af27c1c228f")!)
                }
                .font(.system(size: 10))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                
            }
                        
            Spacer()
            
            Group {
                Text("Already have an account?".uppercased())
                    .font(.system(size: 12))
                
                Button(action: {
                    isSigningUp.toggle()
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
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
            ImagePicker(image: self.$inputImage, source: self.sourceType)
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(""), buttons: [
                .default(Text("Photo Library")) {
                    self.sourceType = .photoLibrary
                    self.showingImagePicker = true
                },
                .default(Text("Camera")) {
                    self.sourceType = .camera
                    self.showingImagePicker = true
                },
                .cancel()
            ])
        }
    }
    
    //MARK: FUNCTIONS
    
    func signUp() {
        if let error = errorCheck(){
            self.error = error
            self.showingAlert = true
            return
        }
        
        session.showActivityIndicatorView = true
        session.signUp(with: email.lowercased(), password: password) { result in
            switch result {
            
            case .success(_):
                setupPushNotifications()
                let userManager = UserManager()
                session.user.name = name
                session.user.username = username
                if let inputImage = inputImage {
                    userManager.uplaodImage(inputImage) { result in
                        session.showActivityIndicatorView = false
                        switch result {
                        
                        case .success(let photoUrl):
                            session.user.profileImageUrl = photoUrl
                            userManager.saveUserData(user: session.user)
                        case .failure(let error):
                            
                            self.error = error.localizedDescription
                            self.showingAlert = true
                        }
                    }
                }
                else {
                    session.showActivityIndicatorView = false
                    userManager.saveUserData(user: session.user)
                }
                
            case .failure(let error):
                session.showActivityIndicatorView = false
                self.error = error.localizedDescription
                self.showingAlert = true
            }
        }
    }
    
    func setupPushNotifications() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.configuteNotifications()
    }

    func errorCheck()->String?{
        if email.trimmingCharacters(in: .whitespaces).isEmpty ||
            password.trimmingCharacters(in: .whitespaces).isEmpty ||
            confirmpassword.trimmingCharacters(in: .whitespaces).isEmpty ||
            name.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Please Fill in all the fields"
        }
        if !(password == confirmpassword) {
            return "Passwords do not match"
        }
        return nil
    }

    func loadImage(){
        guard let inputImage = inputImage else { return}
        profileImage = Image(uiImage: inputImage)
    }
}

struct SignUpView_Previews: PreviewProvider {
    @State static var isSigningUp: Bool = false
    static var previews: some View {
        SignUpView(isSigningUp: $isSigningUp)
    }
}
