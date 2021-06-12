//
//  EventsList.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/12/21.
//

import SwiftUI
import CoreData

struct EventsList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Event.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Event>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    EventsRow(item: item)
                }
            }
            .navigationTitle("Events")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}
