//
//  FavoritesList.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/13/21.
//

import SwiftUI
import CoreData
import CocoaLumberjackSwift

struct FavoritesList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [], predicate: K.Predicate.isFavorite, animation: .default)
    private var favs: FetchedResults<JsonImport>
    
    
    var body: some View {
        List {
            if favs.count > 0 {
                if let persons = (favs.filter{ $0.isKind(of: Person.self )} as? [Person]), persons.count > 0 {
                    Section(header: Text("Founders")) {
                        ForEach(persons.sorted(by: { ($0.lastName ?? "", $0.firstName ?? "") < ($1.lastName ?? "", $1.firstName ?? "")})) { person in
                            FounderRow(subject: person)
                        }
                    }
                }
                if let events = (favs.filter{ $0.isKind(of: Event.self )} as? [Event]), events.count > 0 {
                    Section(header: Text("Events")) {
                        ForEach(events.sorted(by: { $0.name ?? "" < $1.name ?? "" })) { event in
                            EventsRow(item: event)
                        }
                    }
                }
                if let topics = (favs.filter{ $0.isKind(of: Topic.self )} as? [Topic]), topics.count > 0 {
                    Section(header: Text("Topics")) {
                        ForEach(topics.sorted(by: { $0.title ?? "" < $1.title ?? "" })) { topic in
                            TopicsRow(item:topic)
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.automatic)
    }
}
