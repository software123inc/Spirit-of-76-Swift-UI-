//
//  EventRow.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/12/21.
//

import SwiftUI
import CoreData

struct EventsRow: View {
    // This view "owns" the item. Child views (such as the Detail View), will "observe" the item instance when it is passed to the child view.
    @StateObject var item:Event
    
    var body: some View {
        NavigationLink(destination: EventsDetail(item: item)) {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(item.name!)")
                Text(String(item.year)) // We don't want commas
                    .foregroundColor(Color(K.BrandColors.cayenne))
                    .font(.subheadline)
            }
        }
        .isDetailLink(true)
    }
}
