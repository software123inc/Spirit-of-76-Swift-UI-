//
//  StatesPlist.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/11/21.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

struct StatesPlist: Codable {
    let jsonId:Int16
    let sortValue:String?
    let imageName:String?
    let isFavorite:Bool?
    let releaseStatus:Bool?
    
    let abbreviation:String
    let name:String
}

struct StatesImporter {
    static let shared = StatesImporter()
    let itemType = "States"
    let udKey = UserDefaultKeys.plist_states_v1
    
    func doImport_v1(inContext performingContext: NSManagedObjectContext) {
        if !UserDefaults.standard.contains(key:udKey) || !UserDefaults.standard.bool(forKey: udKey) {
            DDLogVerbose("Importing \(itemType) v1.")
            let resourceName = "states_v1"
            if let plistItems = PListImporter.shared.itemList(forResource: resourceName, root: "records") {
                var transformSuccess = true
                PListSeeder.shared.transformPListRecords(plistItems, ofType:StatesPlist.self) { item in
                    guard let item = item as? StatesPlist else {
                        DDLogWarn("item does not conform to \(itemType)Plist")
                        transformSuccess = false
                        return
                    }
                    
                    let fr:NSFetchRequest<States> = States.fetchRequest()
                    fr.predicate = NSPredicate(format: "jsonId == %d", item.jsonId)
                    
                    do {
                        let result = try performingContext.fetch(fr)
                        
                        guard result.isEmpty else {
                            print("\(itemType) \(item.name) already exists")
                            return
                        }
                        
                        // Create Managed Object in child context to prState auto-save when app goes to background.
                        // FIXME: Switch to viewContext
                        let mo = States.init(context: performingContext)
                        mo.jsonId = item.jsonId
                        mo.imageName = item.imageName
                        mo.sortValue = item.sortValue
                        mo.isFavorite = item.isFavorite ?? false
                        mo.releaseStatus = item.releaseStatus ?? true
                        
                        mo.abbreviation = item.abbreviation
                        mo.name = item.name
                        
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

extension StatesImporter {
    func ConfirmStatesAreImported(inContext performingContext: NSManagedObjectContext) {
        let fr:NSFetchRequest<States> = States.fetchRequest()
        
        do {
            let results = try performingContext.fetch(fr)
            
            guard results.isEmpty else {
                DDLogDebug("It appears that states have been imported. \(results.count) records found.")
                return
            }
            DDLogDebug("We must re-import states.")
            UserDefaults.standard.setValue(false, forKey: udKey)
            StatesImporter.shared.doImport_v1(inContext: performingContext)
        }
        catch {
            DDLogError(error.localizedDescription)
        }
    }
}

