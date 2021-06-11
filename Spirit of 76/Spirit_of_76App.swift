//
//  Spirit_of_76App.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/10/21.
//

import SwiftUI

@main
struct Spirit_of_76App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
