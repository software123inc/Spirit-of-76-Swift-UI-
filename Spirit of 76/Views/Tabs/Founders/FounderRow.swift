//
//  FounderRow.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/12/21.
//

import SwiftUI
import CoreData
import CocoaLumberjackSwift

struct FounderRow: View {
    // This view "owns" the Person. Child views (such as the Detail View), will "observe" the Person instance once the Person is passed to the child view.
    @StateObject var subject:Person
    
    var body: some View {
        HStack{
            if let imageName = subject.imageName {
                Image("Avatars/\(imageName)")
                    .resizable()
                    .fixedSize(horizontal: true
                               , vertical: true)
            }
            else {
                Image(systemName: "photo.on.rectangle.angled")
            }
            
            subject.firstName.map(Text.init)
            subject.lastName.map(Text.init)
            NavigationLink(destination: FounderDetail(subject: subject)) {
                    Text("")
                }
            .isDetailLink(true)
        }
    }
}
//
//struct FounderRow_Previews: PreviewProvider {
//    static func previewPerson() -> Person {
//        let previewContext = PersistenceController.preview.container.viewContext
//
//        let pngData = UIImage(systemName: "photo")?.pngData()!
//
//        let thing = PersistenceController.addThing(Person.self, in: previewContext, name: "Person Row", avatarPNG: pngData)
//
//        PersistenceController.saveContext(context: previewContext)
//
//        return thing
//    }
//
//    static var previews: some View {
//        FounderRow(subject: previewPerson())
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}

