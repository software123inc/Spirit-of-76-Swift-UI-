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
    @State var showIPadWelcomView = true
    
    var body: some View {
        ZStack {
            TabView() {
                FoundersList()
                    .tabItem {
                        FoundersTabItem()
                    }
                DocumentsList()
                    .tabItem {
                        DocumentsTabItem()
                    }
                EventsList()
                    .tabItem {
                        EventsTabItem()
                    }
                TopicsList()
                    .tabItem {
                        TopicsTabItem()
                    }
                FavoritesList()
                    .tabItem {
                        FavoritesTabItem()
                    }
                AboutList()
                    .tabItem {
                        AboutTabItem()
                    }
            }
            if UIDevice.current.localizedModel == "iPad" && UIDevice.current.orientation.isPortrait {
                WelcomeView()
                    .opacity(showIPadWelcomView ? 1 : 0)
                    .zIndex(showIPadWelcomView ? 1 : 0)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation() {
                                self.showIPadWelcomView = false
                            }
                        }
                    }
                    .ignoresSafeArea(.all)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
