//
//  FounderDetail.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/12/21.
//

import SwiftUI
import CoreData
//import iPages

struct FounderDetail: View {
    //    @Environment(\.managedObjectContext) private var viewContext
//    @State private var currentPage = 0
    @ObservedObject var subject:Person
    
    var body: some View {
        Text("TBD")
//        iPages(selection: $currentPage) {
//            PlayerDetailPage1(currentPage: $currentPage, subject: subject)
//                .tag(0)
//            Color.red
//                .tag(1)
//            Color.green
//                .tag(2)
//        }
        .navigationTitle(subject.lastName ?? "unnamed founder")
        .navigationBarTitleDisplayMode(.inline)
    }
}
