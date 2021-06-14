//
//  FounderRow.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/12/21.
//

import SwiftUI
import CoreData
import CocoaLumberjackSwift

struct FounderRow: View {
    // This view "owns" the Person. Child views (such as the Detail View), will "observe" the Person instance once the Person is passed to the child view.
    @StateObject var subject:Person
    
    var body: some View {
        HStack {
            if let imageName = subject.imageName {
                Image("Avatars/\(imageName)")
                    .fixedSize(horizontal: true
                               , vertical: true)
            }
            else {
                Image(systemName: "photo.on.rectangle.angled")
            }
            NavigationLink(destination: FounderDetail(subject: subject)) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        subject.firstName.map(Text.init)
                        subject.lastName.map(Text.init)
                    }
                    (subject.summaryText.map(Text.init))
                        .font(.footnote)
                }
            }
            .isDetailLink(true)
        }
    }
}

