//
//  CreditsView.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/13/21.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        VStack {
            K.Images.fife_and_drum
            Text("Books")
                .font(.headline)
            Text("Lives of the Signers of the Declaration of Independence")
                .underline()
                .multilineTextAlignment(.center)
            Text("\nLossing, B.J.; Geo. F. Cooledge & Brother, New York, NY. 1848. Reprinted by Wallbuilder Press, 2008.")
                .multilineTextAlignment(.center)
            Text("🇺🇸")
            Text("Founders' Almanac, The: A Practical Guide to the Notable Events, Greatest Leaders & Most Eloquent Words of the American Founding")
                .underline()
                .multilineTextAlignment(.center)
            Text("\nSpalding, Matthew. 2004")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .navigationTitle("Credits")
    }
}
