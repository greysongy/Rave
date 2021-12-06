//
//  SelectRatingSlider.swift
//  Rave
//
//  Created by Bernie Cartin on 7/28/21.
//

import SwiftUI

struct SelectRatingSlider: View {
    
    @Binding var rating: Int
    @Binding var width: CGFloat
    var maxWidth: CGFloat = 200
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.black.opacity(0.2))
                .frame(width: maxWidth, height: 30)
            
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("BlueDark"), Color("BlueMedium"), Color("BlueLight")]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: width, height: 30)
            
            ZStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color("BlueDark"))
                    .offset(x: width - 18)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                if checkBounds(location: value.location.x) {
                                    self.width = value.location.x
                                    self.rating = getValue(from: value.location.x)
                                }
                            })
                    )
                
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

struct SelectRatingSlider_Previews: PreviewProvider {
    static var previews: some View {
        SelectRatingSlider(rating: .constant(3), width: .constant(40.0))
            .previewLayout(.sizeThatFits)
    }
}
