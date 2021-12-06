//
//  AddPostView.swift
//  Rave
//
//  Created by Bernie Cartin on 6/18/21.
//

import SwiftUI
import AlertToast

struct AddPostView: View {
    // MARK: PROPERTIES
    
    @EnvironmentObject var session: SessionManager
    
    @State private var topic: String = ""
    @State private var selectedCategory: Int = 0
    @State private var selectedRating = 0
    @State private var width: CGFloat = 0
    @State private var comments = ""
    
    @State private var showingImagePicker = false
    @State private var inputImage : UIImage?
    @State var postImage : Image? 
    
    @State private var showingActionSheet = false
    @State private var sourceType : UIImagePickerController.SourceType = .photoLibrary
    
    @State var error : String = ""
    @State private var showingAlert = false
    
    @State private var showingToast = false
        
    let categories = ["Entertainment", "Food", "Music", "Event", "Place"]
    
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Review")) {
                    TextField("What are you reviewing?", text: $topic)
 
                    Picker(selection: $selectedCategory, label: Text("Category"), content: {
                        ForEach(0 ..< categories.count) {
                            Text(categories[$0])
                        }
                    })
                    
                    HStack {
                        Text("Rating")
                        Spacer()
//                        SelectRatingView(rating: $selectedRating)
                        SelectRatingSlider(rating: $selectedRating, width: $width)
                    }
                }
                
                Section(header: Text("Comments")) {
                    ZStack {
                        TextEditor(text: $comments)
                            .frame(height: 64)
                        
                        if comments.isEmpty {
                            VStack {
                                HStack {
                                    Text("Add some comments to your review")
                                        .font(.body)
                                        .foregroundColor(.black.opacity(0.2))
                                        .padding(.top, 8)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                }
                
                Section(header: Text("Photos")) {
                    if let postImage = postImage {
                        VStack(alignment: .center) {
                            HStack(alignment: .lastTextBaseline) {
                                Spacer()
                                postImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 300, height: 300)
                                    .clipped()
                                Spacer()
                            }
                        }
                        Button(action: {
                            self.postImage = nil
                            self.inputImage = nil
                        }, label: {
                            HStack {
                                Image(systemName: "trash")
                                    .foregroundColor(Color("BlueDark"))
                                Text("Remove photo")
                                    .foregroundColor(Color("BlueDark"))
                            }
                        })
                    }
                    else {
                        Button(action: {
                            self.showingActionSheet = true
                        }, label: {
                            HStack {
                                Image(systemName: "plus.square.on.square")
                                    .foregroundColor(Color("BlueDark"))
                                Text("Add a photo")
                                    .foregroundColor(Color("BlueDark"))
                            }
                        })
                    }
                }
                                
                Button(action: {
                    savePost()
                }, label: {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("POST")
                        Spacer()
                    }
                        
                })
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(C_ERROR), message: Text(error), dismissButton: .default(Text("OK")))
                }
                
            }
            .navigationTitle("Post a Review")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
                ImagePicker(image: self.$inputImage, source: self.sourceType, allowsEditing: false)
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
                AlertToast(displayMode: .alert, type: .regular, title: "POSTED")
            })
        }
    }
    
    //MARK: FUNCTIONS
    
    private func loadImage(){
        guard let inputImage = inputImage else { return}
        postImage = Image(uiImage: inputImage)
    }
    
    private func errorCheck()->String?{
        if topic.trimmingCharacters(in: .whitespaces).isEmpty ||
            selectedRating == 0 {
            return "Please Fill in all the fields"
        }
        return nil
    }
    
    private func savePost() {
        if let error = errorCheck(){
            self.error = error
            self.showingAlert = true
            return
        }
        
        session.showActivityIndicatorView = true
        let postManager = PostManager()
        if let inputImage = inputImage {
            postManager.uplaodImage(inputImage) { result in
                switch result {
                
                case .success(let imageUrl):
                    let post = Post(topic: self.topic, imageUrl: imageUrl, category: categories[selectedCategory], review: selectedRating, comments: comments.count > 0 ? comments : nil, createdBy: session.user.id, date: Date())
                    postManager.savePost(post: post) { result in
                        switch result {
                        
                        case .success(_):
                            cleanUp()
                            session.showActivityIndicatorView = false
                            showingToast.toggle()
                        case .failure(let error):
                            session.showActivityIndicatorView = false
                            self.error = error.localizedDescription
                            self.showingAlert.toggle()
                        }
                    }
                case .failure(let error):
                    session.showActivityIndicatorView = false
                    self.error = error.localizedDescription
                    self.showingAlert.toggle()
                }
            }
        }
        else {
            let post = Post(id: UUID().uuidString, topic: self.topic, imageUrl: nil, category: categories[selectedCategory], review: selectedRating, comments: comments.count > 0 ? comments : nil, createdBy: session.user.id, date: Date())
            postManager.savePost(post: post) { result in
                switch result {
                
                case .success(_):
                    cleanUp()
                    session.showActivityIndicatorView = false
                    showingToast.toggle()
                case .failure(let error):
                    session.showActivityIndicatorView = false
                    self.error = error.localizedDescription
                    self.showingAlert.toggle()
                }
            }
        }
    }
    
    private func cleanUp() {
        self.topic = ""
        self.selectedCategory = 0
        self.selectedRating = 0
        self.width = 0
        self.comments = ""
        self.inputImage = nil
        self.postImage = nil
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
            .environmentObject(SessionManager())
    }
}
