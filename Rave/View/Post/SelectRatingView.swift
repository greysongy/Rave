//
//  SelectRatingView.swift
//  Rave
//
//  Created by Bernie Cartin on 6/19/21.
//

import SwiftUI

struct SelectRatingView: View {
    @Binding var rating: Int
    var label = ""
    var maximumRating = 5
    var offImage = Image(systemName: "star")
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color("BlueDark")
    
    var body: some View {
        HStack {
            ForEach(1 ..< maximumRating + 1) { number in
                self.image(for: number)
                    .font(.title2)
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = number
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage //?? onImage
        } else {
            return onImage
        }
    }
}

struct SelectRatingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectRatingView(rating: .constant(3))
            .previewLayout(.sizeThatFits)
    }
}


