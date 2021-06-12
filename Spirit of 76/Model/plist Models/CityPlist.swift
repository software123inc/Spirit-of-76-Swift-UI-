//
//  CityPlist.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/11/21.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

struct CityPlist: Codable {
    let jsonId:Int16
    let sortValue:String?
    let imageName:String?
    let isFavorite:Bool?
    let releaseStatus:Bool?
    
    let name:String
    let notes:String?
    let synopsis:String?
    
    // Foreign Keys
    let stateId:Int16
}

struct CityImporter {
    static let shared = CityImporter()
    let itemType = "City"
    
    func doImport_v1(inContext performingContext: NSManagedObjectContext) {
        let udKey = UserDefaultKeys.plist_cities_v1
        
        if !UserDefaults.standard.contains(key:udKey) || !UserDefaults.standard.bool(forKey: udKey) {
            DDLogVerbose("Importing \(itemType)s v1.")
            let resourceName = "Cities_v1".lowercased()
            if let plistItems = PListImporter.shared.itemList(forResource: resourceName, root: "records") {
                var transformSuccess = true
                PListSeeder.shared.transformPListRecords(plistItems, ofType:CityPlist.self) { item in
                    guard let item = item as? CityPlist else {
                        DDLogWarn("item does not conform to \(itemType)Plist")
                        transformSuccess = false
                        return
                    }
                    
                    let fr:NSFetchRequest<City> = City.fetchRequest()
                    fr.predicate = NSPredicate(format: "jsonId == %d", item.jsonId)
                    
                    do {
                        let result = try performingContext.fetch(fr)
                        
                        guard result.isEmpty else {
                            print("\(itemType) \(item.name) already exists")
                            return
                        }
                        
                        // Create Managed Object in child context to prCity auto-save when app goes to background.
                        // FIXME: Switch to viewContext
                        let mo = City.init(context: performingContext)
                        mo.jsonId = item.jsonId
                        mo.imageName = item.imageName
                        mo.sortValue = item.sortValue
                        mo.isFavorite = item.isFavorite ?? false
                        mo.releaseStatus = item.releaseStatus ?? true
                        
                        mo.name = item.name
                        mo.notes = item.notes
                        mo.synopsis = item.synopsis
                        
                        // Do Relationships
                        relate(city: mo, toStateId: item.stateId, inContext: performingContext)
                        
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

extension CityImporter {
    func relate(city:City, toStateId stateId:Int16?, inContext context:NSManagedObjectContext) {
        guard let stateId = stateId  else {
            return
        }
        
        let fr:NSFetchRequest<State> = State.fetchRequest()
        fr.predicate = NSPredicate(format: "jsonId == %d", stateId)
        
        do {
            let state = try context.fetch(fr).first
            state?.addToCities(city)
        }
        catch {
            DDLogError(error)
        }
    }
}
