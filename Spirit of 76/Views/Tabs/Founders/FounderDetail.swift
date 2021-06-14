//
//  FounderDetail.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/12/21.
//

import SwiftUI
import CoreData
import CocoaLumberjackSwift

struct FounderDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var subject:Person
    
    var body: some View {
        List {
            VStack {
                HStack {
                    if let imageName = subject.imageName {
                        Image("\(imageName)")
                            .fixedSize(horizontal: true
                                       , vertical: true)
                    }
                    if let imageName = subject.residenceState?.imageName {
                        Image("\(imageName)_blue")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                Text("\(subject.summaryText ?? "")")
            }
            if let education = subject.educations?.sortedArray(using: [K.SortBy.titleASC]) as? [Education], education.count > 0 {
                Section(header: Text("Education")) {
                    ForEach(education) { item in
                        VStack {
                            item.title.map(Text.init)
                                .font(.headline)
                            item.notes.map(Text.init)
                                .font(.body)
                        }
                    }
                }
            }
            if let facts = subject.facts?.sortedArray(using: [K.SortBy.titleASC]) as? [Fact], facts.count > 0 {
                Section(header: Text("Facts")) {
                    ForEach(facts) { item in
                        VStack {
                            item.title.map(Text.init)
                                .font(.headline)
                            item.notes.map(Text.init)
                                .font(.body)
                        }
                    }
                    
                }
            }
            if let professions = subject.professions?.sortedArray(using: [K.SortBy.titleASC]) as? [Profession], professions.count > 0 {
                Section(header: Text("Professions")) {
                    ForEach(professions) { item in
                        VStack {
                            item.title.map(Text.init)
                                .font(.headline)
                            item.notes.map(Text.init)
                                .font(.body)
                        }
                    }
                }
            }
            if let quotes = subject.quotes?.sortedArray(using: [K.SortBy.quotationASC]) as? [Quote], quotes.count > 0 {
                Section(header: Text("Quotes")) {
                    ForEach(quotes) { item in
                        VStack {
                            item.quotation.map(Text.init)
                                .font(.body)
                        }
                    }
                }
            }
        }
        .navigationTitle("\(subject.firstName ?? "") \(subject.lastName ?? "")")
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarItems(trailing: IsFavoriteToggleButton(subject: subject))
    }
}
