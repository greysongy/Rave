//
//  TutorialView.swift
//  Rave
//
//  Created by Bernie Cartin on 11/3/21.
//

import SwiftUI

struct TutorialView: View {
    @AppStorage(C_SHOWTUTORIAL) private var showTutorial = true
    
    var body: some View {
        VStack {
            Text("Rave about it.")
                .foregroundColor(Color("BlueDark"))
                .font(.system(size: 32, weight: .bold, design: .default))
                .padding()
                .padding(.top, 42)
            
            Text("You know that netflix series you just binged, or that new coffee spot you just tried? Rate it to let your friends know what you think.")
                .foregroundColor(Color("BlueDark"))
                .multilineTextAlignment(.center)
                .font(.system(size: 17, weight: .bold, design: .default))
                .padding(.vertical)
                .padding(.horizontal, 32)
            
            Image("rate_example")
                .resizable()
                .frame(width: 342, height: 150)
                .scaledToFill()
            
            Text("Slide the star until you reach your opinion. Add some text or an image and share it!")
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center)
                .font(.custom("BradleyHandITCTT-Bold", size: 18))
                .padding(.top, 24)
                .padding(.horizontal, 36)
                .padding(.bottom, 48)
            
            HStack {
                VStack(alignment: .trailing, spacing: 8) {
                    HStack(spacing: 0){
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                    }
                    HStack(spacing: 0){
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                    }
                    HStack(spacing: 0){
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                    }
                    HStack(spacing: 0){
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                    }
                    HStack(spacing: 0){
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("BlueDark"))
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                        Text("= Terrible")
                            .fontWeight(.bold)
                            .foregroundColor(Color("BlueDark"))

                        Text("= Bad")
                            .fontWeight(.bold)
                            .foregroundColor(Color("BlueDark"))

                        Text("= Okay")
                            .fontWeight(.bold)
                            .foregroundColor(Color("BlueDark"))

                        Text("= Good")
                            .fontWeight(.bold)
                            .foregroundColor(Color("BlueDark"))

                        Text("= Great")
                            .fontWeight(.bold)
                            .foregroundColor(Color("BlueDark"))
                }
            }
            
            Text("Rate moview, TV shows, Restaurants, Books, Songs, & More.")
                .foregroundColor(Color("BlueDark"))
                .multilineTextAlignment(.center)
                .font(.system(size: 13, weight: .bold, design: .default))
                .padding(.vertical)
                .padding(.horizontal, 32)
                .padding(.bottom, 42)
            
            Button(action: {
                self.showTutorial = false
            }, label: {
                Text("GOT IT")
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
            
            Spacer()
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
