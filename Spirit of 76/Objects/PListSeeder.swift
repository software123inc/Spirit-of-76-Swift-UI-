//
//  PListSeeder.swift
//  Spirit of 76
//
//  Created by Tim Newton on 6/11/21.
//

import SwiftUI
import CoreData
import CocoaLumberjackSwift

struct PListSeeder {
    
    static let shared = PListSeeder()
    private let plistRootElement = "records"
    private let dateFormatter = DateFormatter()
    
    func getSeedFilesAndImport() {
        let vc = PersistenceController.shared.container.viewContext
        CountryImporter.shared.doImport_v1(inContext: vc)
        StatesImporter.shared.doImport_v1(inContext: vc)
        EventImporter.shared.doImport_v1(inContext: vc)
        TopicImporter.shared.doImport_v1(inContext: vc)
        WritingImporter.shared.doImport_v1(inContext: vc)

        CityImporter.shared.doImport_v1(inContext: vc) // ForeignKey > state
        PersonImporter.shared.doImport_v1(inContext: vc) // ForeignKey > state, country

        EducationImporter.shared.doImport_v1(inContext: vc)
        FactImporter.shared.doImport_v1(inContext: vc)
        ProfessionImporter.shared.doImport_v1(inContext: vc)
        AuthorshipImporter.shared.doImport_v1(inContext: vc)
        QuoteImporter.shared.doImport_v1(inContext: vc)
        
        if StatesImporter.shared.ConfirmStatesAreImported(inContext: vc) {
            PersonImporter.shared.sync_states(inContext: vc)
        }
    }
    
    func transformPListRecords<C:Codable>(_ records:plistRecord, ofType codeable:C.Type, transformationHandler:plistDataSetToManagedObjectTransformerClosure) {
        do {
            let json = try JSONSerialization.data(withJSONObject: records)
            let decoder = JSONDecoder()
            let decodedItems = try decoder.decode([C].self, from: json)
            decodedItems.forEach { item in
                transformationHandler(item)
            }
        } catch {
            DDLogError(error)
        }
    }
    
    func date(fromString dateString:String?) -> Date? {
        var dateFromString:Date?
        if let dateString = dateString {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFromString = dateFormatter.date(from: dateString)
        }
        
        return dateFromString
    }
}
