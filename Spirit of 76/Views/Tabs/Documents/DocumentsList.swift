//
//  DocumentsList.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/13/21.
//

import SwiftUI

struct DocumentsList: View {
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Image(systemName: "doc.plaintext")
                    NavigationLink(destination: AttributedTextView(DeclarationOfIndependence.shared.attributedString(), navTitle: "Declaration of Independence")) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Declaration of Independence")
                            Text("1776")
                                .font(.subheadline)
                                .foregroundColor(Color(K.BrandColors.cayenne))
                        }
                    }
                    .isDetailLink(true)
                }
                HStack {
                    Image(systemName: "doc.plaintext")
                    NavigationLink(destination: AttributedTextView(ArticlesOfConfederation.shared.attributedString(), navTitle: "Articles of Confederation")) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Articles of Confederation")
                            Text("1777")
                                .font(.subheadline)
                                .foregroundColor(Color(K.BrandColors.cayenne))
                        }
                    }
                    .isDetailLink(true)
                }
                HStack {
                    Image(systemName: "doc.plaintext")
                    NavigationLink(destination: AttributedTextView(USConstitution.shared.attributedString(), navTitle: "U.S. Constitution")) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("U.S. Constitution")
                            Text("1787")
                                .font(.subheadline)
                                .foregroundColor(Color(K.BrandColors.cayenne))
                        }
                    }
                    .isDetailLink(true)
                }
            }
            .navigationTitle("Documents")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}
