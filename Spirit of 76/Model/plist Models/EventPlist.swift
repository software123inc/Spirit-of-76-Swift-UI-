//
//  EventPlist.swift
//  Spirit of 76
//
//  Created by Tim Newton on 6/11/21.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

struct EventPlist: Codable {
    let jsonId:Int16
    let sortValue:String?
    let imageName:String?
    let isFavorite:Bool?
    let releaseStatus:Bool?
    
    let asOfDate:String?
    let endDate:String?
    let endYear:Int16?
    
    let name:String
    let notes:String?
    let synopsis:String?    
    let year:Int16
}

struct EventImporter {
    static let shared = EventImporter()
    let itemType = "Event"
    
    func doImport_v1(inContext performingContext: NSManagedObjectContext) {
        let udKey = UserDefaultKeys.plist_events_v1
        
        if !UserDefaults.standard.contains(key:udKey) || !UserDefaults.standard.bool(forKey: udKey) {
            DDLogVerbose("Importing \(itemType)s v1.")
            let resourceName = "events_v1"
            if let plistItems = PListImporter.shared.itemList(forResource: resourceName, root: "records") {
                var transformSuccess = true
                PListSeeder.shared.transformPListRecords(plistItems, ofType:EventPlist.self) { item in
                    guard let item = item as? EventPlist else {
                        DDLogWarn("item does not conform to \(itemType)Plist")
                        transformSuccess = false
                        return
                    }
                    
                    let fr:NSFetchRequest<Event> = Event.fetchRequest()
                    fr.predicate = NSPredicate(format: "jsonId == %d", item.jsonId)
                    
                    do {
                        let result = try performingContext.fetch(fr)
                        
                        guard result.isEmpty else {
                            print("\(itemType) \(item.name) already exists")
                            return
                        }
                        
                        // Create Managed Object in child context to prevent auto-save when app goes to background.
                        // FIXME: Switch to viewContext
                        let mo = Event.init(context: performingContext)
                        mo.jsonId = item.jsonId
                        mo.imageName = item.imageName
                        mo.sortValue = item.sortValue
                        mo.isFavorite = item.isFavorite ?? false
                        mo.releaseStatus = item.releaseStatus ?? true
                        
                        mo.asOfDate = PListSeeder.shared.date(fromString: item.asOfDate)
                        mo.endDate = PListSeeder.shared.date(fromString: item.endDate)
                        mo.endYear = item.endYear ?? 0
                        mo.name = item.name
                        mo.notes = item.notes
                        mo.synopsis = item.synopsis
                        mo.year = item.year
                        
                        PersistenceController.saveContext(context: performingContext)
                        DDLogVerbose("Created \(itemType) '\(String(describing: mo.name))'.")
                    }
                    catch {
                        transformSuccess = false
                        DDLogError(error)
                    }
                    
                    PersistenceController.saveContext(context: performingContext)
                }
                UserDefaults.standard.setValue(transformSuccess, forKey: udKey)
            }
            else {
                DDLogWarn("Could not load \(resourceName)")
            }
        }
        else {
            DDLogVerbose("Bypass Importing \(itemType)s v1.")
        }
    }
}
