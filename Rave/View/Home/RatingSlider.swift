//
//  RatingSlider.swift
//  Rave
//
//  Created by Bernie Cartin on 11/2/21.
//

import SwiftUI

struct RatingSlider: View {
    
    @State var rating: Int
    @State var width: CGFloat
    var maxWidth: CGFloat = 200
    
    var body: some View {
 
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.black.opacity(0.2))
                    .frame(width: maxWidth, height: 30)
                
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("BlueDark"), Color("BlueMedium"), Color("BlueLight")]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: width, height: 30)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.4 * Double(rating))) {
                            self.width = CGFloat((rating * 40))
                        }
                    }
                
                ZStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color("BlueDark"))
                        .offset(x: width - 18)
                    
                    Text("\(rating)")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: width - 18)
                }
                
                
            }
    }
    
    func getValue(from location: CGFloat) -> Int {
        return Int(((location / maxWidth) * 5) + 0.2)
    }
    
    func checkBounds(location: CGFloat) -> Bool {
        if location / maxWidth >= 0 && location / maxWidth <= 1 {
            return true
        }
        else {
            return false
        }
    }
}

struct RatingSlider_Previews: PreviewProvider {
    static var previews: some View {
        SelectRatingSlider(rating: .constant(3), width: .constant(40.0))
            .previewLayout(.sizeThatFits)
    }
}
