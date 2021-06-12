//
//  FoundersList.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/12/21.
//

import CoreData
import SwiftUI

struct FoundersList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.lastName, ascending: true),
                          NSSortDescriptor(keyPath: \Person.firstName, ascending: true)],
        predicate: NSPredicate(format: "releaseStatus == YES"),
        animation: .default)
    private var results: FetchedResults<Person>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(results, id:\.objectID) {
                    FounderRow(subject: $0)
                }
            }
            .navigationTitle("Founders")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}
