//
//  IsFavoriteToggleButton.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/13/21.
//

import SwiftUI
struct IsFavoriteToggleButton: View {
    @ObservedObject var subject:JsonImport
    
    var body: some View {
        Button(action: {
            self.subject.isFavorite.toggle()
        }) {
            if self.subject.isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color(K.BrandColors.cayenne))
            } else {
                Image(systemName: "heart")
                    .foregroundColor(Color.gray)
            }
        }}
}
