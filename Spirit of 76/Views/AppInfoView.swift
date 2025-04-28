//
//  AppInfoView.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/13/21.
//

import SwiftUI

struct AppInfoView: View {
    var body: some View {
        VStack {
            K.Images.fife_and_drum
                .clipShape(RoundedRectangle(cornerRadius: 15))
            Text("Spirit of '76")
            Text("🇺🇸\n🇺🇸")
            Text("Copyright 2020 by EduServe, Inc. All Rights Reserved.")
                .multilineTextAlignment(.center)
            Text("Version \(K.appVersion)")
                .font(.footnote)
        }
        .navigationTitle("App Info")
    }
}
