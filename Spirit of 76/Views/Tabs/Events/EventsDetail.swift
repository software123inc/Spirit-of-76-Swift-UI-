//
//  EventDetail.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/12/21.
//

import SwiftUI
import CoreData

struct EventsDetail: View {
    @ObservedObject var item:Event
    
    var body: some View {
        VStack {
            if let imageName = item.imageName {
                Image("\(imageName)")
                    .fixedSize(horizontal: true, vertical: true)
            }
            ScrollView {
                if item.notes != nil {
                    item.notes.map(Text.init)
                        .padding()
                }
                else {
                    item.synopsis.map(Text.init)
                        .padding()
                }
            }
        }
        .navigationTitle(item.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}
