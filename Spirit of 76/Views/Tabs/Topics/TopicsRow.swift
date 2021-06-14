//
//  TopicsRow.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/12/21.
//

import SwiftUI
import CoreData

struct TopicsRow: View {
    // This view "owns" the item. Child views (such as the Detail View), will "observe" the item instance when it is passed to the child view.
    @StateObject var item:Topic
    
    var body: some View {
        NavigationLink(destination: TopicsDetail(item: item)) {
            Text("\(item.title!)")
        }
        .isDetailLink(true)
    }
}
