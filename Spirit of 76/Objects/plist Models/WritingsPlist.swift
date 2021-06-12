//
//  WritingsPlist.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/11/21.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

struct WritingPlist: Codable {
    let jsonId:Int16
    let sortValue:String?
    let imageName:String?
    let isFavorite:Bool?
    let releaseStatus:Bool?
    
    let amazonLink:String?
    let notes:String
    let synopsis:String?
    let title:String
}

struct WritingImporter {
    static let shared = WritingImporter()
    let itemType = "Writing"
    
    func doImport_v1(inContext performingContext: NSManagedObjectContext) {
        let udKey = UserDefaultKeys.plist_writings_v1
        
        if !UserDefaults.standard.contains(key:udKey) || !UserDefaults.standard.bool(forKey: udKey) {
            DDLogInfo("Importing \(itemType)s v1.")
            let resourceName = "Writings_v1".lowercased()
            if let plistItems = PListImporter.shared.itemList(forResource: resourceName, root: "records") {
                var transformSuccess = true
                PListSeeder.shared.transformPListRecords(plistItems, ofType:WritingPlist.self) { item in
                    guard let item = item as? WritingPlist else {
                        DDLogWarn("item does not conform to \(itemType)Plist")
                        transformSuccess = false
                        return
                    }
                    
                    let fr:NSFetchRequest<Writing> = Writing.fetchRequest()
                    fr.predicate = NSPredicate(format: "jsonId == %d", item.jsonId)
                    
                    do {
                        let result = try performingContext.fetch(fr)
                        
                        guard result.isEmpty else {
                            print("\(itemType) \(item.title) already exists")
                            return
                        }
                        
                        // Create Managed Object in child context to prWriting auto-save when app goes to background.
                        // FIXME: Switch to viewContext
                        let mo = Writing.init(context: performingContext)
                        mo.jsonId = item.jsonId
                        mo.imageName = item.imageName
                        mo.sortValue = item.sortValue
                        mo.isFavorite = item.isFavorite ?? false
                        mo.releaseStatus = item.releaseStatus ?? true
                        
                        mo.amazonLink = item.amazonLink
                        mo.notes = item.notes
                        mo.synopsis = item.synopsis
                        mo.title = item.title
                        
                        PersistenceController.saveContext(context: performingContext)
                        DDLogVerbose("Created \(itemType) '\(String(describing: mo.title))'.")
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
            DDLogInfo("Bypass Importing \(itemType)s v1.")
        }
    }
}



