//
//  WelcomeView.swift
//  Spirit of 76
//
//  Created by Tim Newton on 6/14/21.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            K.Images.fife_and_drum
            Text("Welcome to Spirit of 76!")
                .font(.largeTitle)
            
            Text("Please select a founder from the left-hand menu; swipe from the left edge to show it.")
                .foregroundColor(.secondary)
        }
    }
}
