//
//  PListSeeder.swift
//  Spirit of 76
//
//  Created by Tim Newton on 6/11/21.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

struct PListSeeder {
    static let shared = PListSeeder()
    private let plistRootElement = "records"
    private let dateFormatter = DateFormatter()
    
    func getSeedFilesAndImport() {
        PersistenceController.shared.container.performBackgroundTask {
            CountryImporter.shared.doImport_v1(inContext: $0)
            EventImporter.shared.doImport_v1(inContext: $0)
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
