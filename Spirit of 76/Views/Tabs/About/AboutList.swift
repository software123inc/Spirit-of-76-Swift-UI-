//
//  AboutList.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/12/21.
//

import SwiftUI

struct AboutList: View {
    let applicationItems = [
        AboutItem(imageName: "book.circle", name: "Credits"),
        AboutItem(imageName: "info.circle", name: "App Info"),
    ]
    
    let feedbackItems = [
        AboutItem(imageName: "star.circle", name: "Rate Me"),
        AboutItem(imageName: "envelope.circle", name: "Send Email"),
    ]
    
    var body: some View {
        List {
            Section(header: FeedbackHeader()) {
                ForEach(feedbackItems) { item in
                    AboutRow(item: item)
                }
            }
            Section(header: AboutHeader()) {
                ForEach(applicationItems) { item in
                    AboutRow(item: item)
                }
            }
        }.listStyle(GroupedListStyle())
    }
}

struct AboutItem: Identifiable {
    var id = UUID()
    var imageName:String
    var name: String
}

struct AboutRow: View {
    var item: AboutItem
    
    var body: some View {
        HStack {
            Image(systemName: item.imageName)
            Text(item.name)
        }
    }
}

struct AboutHeader: View {
    var body: some View {
        HStack {
            Image(systemName: "bell")
            Text("Spirit of 76")
        }
    }
}

struct FeedbackHeader: View {
    var body: some View {
        HStack {
            Image(systemName: "bell")
            Text("Feedback")
        }
    }
}
