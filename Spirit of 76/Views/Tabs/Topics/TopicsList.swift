//
//  TopicsList.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/12/21.
//

import SwiftUI
import CoreData

struct TopicsList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Topic.title, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Topic>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    TopicsRow(item: item)
                }
            }
            .navigationTitle("Topics")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}
