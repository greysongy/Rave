//
//  EditProfileView.swift
//  Rave
//
//  Created by Bernie Cartin on 6/18/21.
//

import SwiftUI
import AlertToast

struct EditProfileView: View {
    // MARK: PROPERTIES
    
    @EnvironmentObject var session: SessionManager
    
    @State private var currentpassword : String = ""
    @State private var newpassword : String = ""
    @State private var confirmpassword : String = ""
    
    @State private var showingImagePicker = false
    @State private var inputImage : UIImage?
    @State var profileImage : Image?
    
    @State private var showingActionSheet = false
    @State private var sourceType : UIImagePickerController.SourceType = .photoLibrary
    
    @State private var photoUpdated = false
    
    @State var error : String = ""
    @State private var showingAlert = false
    @State private var showingAlertPasswordChange = false
    
    @State private var showingToast = false
    
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
        
    // MARK: BODY
    var body: some View {
        VStack(spacing: 12) {
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding(.leading)
                })
                
                Spacer()
                
                Text("Edit Profile")
                    .font(.title3)
                    .padding()
                    .padding(.trailing, 42)
                
                Spacer()
            }
            
            ZStack{
                if profileImage != nil {
                    profileImage!
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100, alignment: .center)
                        .onTapGesture {
                            self.showingActionSheet = true
                        }
                }else {
                    Image("default")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100, alignment: .center)
                        .onTapGesture {
                            self.showingActionSheet = true
                        }
                }
            }
            
            Group {
                TextField("Name", text: $session.user.name)
                    .padding(12)
                    .background(
                        Color(.black).opacity(0.1)
                    )
                    .padding(.horizontal, 24)
                
                TextField("Username", text: $session.user.username)
                    .padding(12)
                    .background(
                        Color(.black).opacity(0.1)
                    )
                    .padding(.horizontal, 24)
                
                ZStack {
                    TextEditor(text: $session.user.bio)
                        .background(
                            Color(.black).opacity(0.1)
                        )
                        .padding(.horizontal, 24)
                    
                    if session.user.bio.isEmpty {
                        VStack {
                            HStack {
                                Text("Bio")
                                    .font(.body)
                                    .foregroundColor(.black.opacity(0.2))
                                    .padding(12)
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            Spacer()
                        }
                    }
                }
                .frame(height: 96)
                
                Button(action: {
                    saveData()
                }, label: {
                    Text("SAVE")
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
                    Alert(title: Text(C_ERROR), message: Text(error), dismissButton: .default(Text("OK")))
                }
                
            }
            
            Spacer()
                .frame(height: 24)
            
            Group {
                Text("Change Password".uppercased())
                    .font(.system(size: 12))
                
                TextField("Current Password", text: $currentpassword)
                    .padding(12)
                    .background(
                        Color(.black).opacity(0.1)
                    )
                    .padding(.horizontal, 24)
                
                SecureField("New Password", text: $newpassword)
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
                    
                }, label: {
                    Text("SAVE PASSWORD")
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
                .alert(isPresented: $showingAlertPasswordChange) {
                    Alert(title: Text(C_ERROR), message: Text(error), dismissButton: .default(Text("OK")))
                }
                
                Spacer()
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
        .toast(isPresenting: $showingToast, alert: {
            AlertToast(displayMode: .alert, type: .regular, title: "SAVED")
        })
        .onAppear(perform: {
            loadData()
        })
    }
    
    //MARK: FUNCTIONS
    
    private func loadData() {
        if let url = session.user.profileImageUrl {
            UserManager().loadImage(url) { result in
                switch result {
                
                case .success(let image):
                    profileImage = Image(uiImage: image)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func saveData() {
        if let error = errorCheck(){
            self.error = error
            self.showingAlert = true
            return
        }
        
        let userManager = UserManager()
        if photoUpdated {
            if let photoUrl = session.user.profileImageUrl {
                userManager.deleteImage(photoUrl) { result in }
            }
            guard let inputImage = inputImage else {return}
            userManager.uplaodImage(inputImage) { result in
                switch result {
                case .success(let photoUrl):
                    session.user.profileImageUrl = photoUrl
                    userManager.saveUserData(user: session.user)
                    showingToast.toggle()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        else {
            userManager.saveUserData(user: session.user)
            showingToast.toggle()
        }
    }
    
    private func changePassword() {
        if let error = errorCheckPasswordChange(){
            self.error = error
            self.showingAlertPasswordChange = true
            return
        }
        
        session.changePassword(oldpassword: currentpassword, newPassword: newpassword) { result in
            switch result {
            
            case .success(_):
                showingToast.toggle()
            case .failure(let error):
                self.error = error.localizedDescription
                self.showingAlertPasswordChange = true
            }
        }
    }

    private func errorCheck()->String?{
        if session.user.name.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Name cannot be blank"
        }
        if !(newpassword == confirmpassword) {
            return "Passwords do not match"
        }
        return nil
    }
    
    private func errorCheckPasswordChange()->String?{
        if currentpassword.trimmingCharacters(in: .whitespaces).isEmpty || newpassword.trimmingCharacters(in: .whitespaces).isEmpty || confirmpassword.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Please fill in all the fields."
        }
        if !(newpassword == confirmpassword) {
            return "Passwords do not match"
        }
        return nil
    }

    func loadImage(){
        guard let inputImage = inputImage else { return}
        photoUpdated = true
        profileImage = Image(uiImage: inputImage)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .environmentObject(SessionManager())
    }
}
