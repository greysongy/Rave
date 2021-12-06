//
//  RatingView.swift
//  Rave
//
//  Created by Bernie Cartin on 7/22/21.
//

import SwiftUI

struct RatingView: View {
    var rating: Int
    var label = ""
    var maximumRating = 5
    var offImage = Image(systemName: "star")
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color("BlueDark")
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(1 ..< maximumRating + 1) { number in
                self.image(for: number)
                    .font(.title2)
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
            }
            
            Text(Rating(rawValue: rating)?.stringValue() ?? "")
                .fontWeight(.bold)
                .padding(.horizontal, 24)
                .padding(.vertical, 4)
                .foregroundColor(.white)
                .background(Color("BlueMedium"))
                .padding(.horizontal)
            Spacer()
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage 
        } else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 3)
            .previewLayout(.sizeThatFits)
    }
}
