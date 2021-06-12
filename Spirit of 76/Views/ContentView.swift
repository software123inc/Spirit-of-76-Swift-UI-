//
//  ContentView.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/10/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ZStack {
            TabView() {
                FoundersList()
                    .tabItem {
                        FoundersTabItem()
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
