//
//  ProfessionPlist.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/11/21.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

struct ProfessionPlist: Codable {
    let jsonId:Int16
    let sortValue:String?
    let imageName:String?
    let isFavorite:Bool?
    let releaseStatus:Bool?
    
    let notes:String
    let synopsis:String?
    let title:String
    let signerId:Int16?
}

struct ProfessionImporter {
    static let shared = ProfessionImporter()
    let itemType = "Profession"
    
    func doImport_v1(inContext performingContext: NSManagedObjectContext) {
        let udKey = UserDefaultKeys.plist_professions_v1
        
        if !UserDefaults.standard.contains(key:udKey) || !UserDefaults.standard.bool(forKey: udKey) {
            DDLogInfo("Importing \(itemType)s v1.")
            let resourceName = "\(itemType)s_v1".lowercased()
            if let plistItems = PListImporter.shared.itemList(forResource: resourceName, root: "records") {
                var transformSuccess = true
                PListSeeder.shared.transformPListRecords(plistItems, ofType:ProfessionPlist.self) { item in
                    guard let item = item as? ProfessionPlist else {
                        DDLogWarn("item does not conform to \(itemType)Plist")
                        transformSuccess = false
                        return
                    }
                    
                    let fr:NSFetchRequest<Profession> = Profession.fetchRequest()
                    fr.predicate = NSPredicate(format: "jsonId == %d", item.jsonId)
                    
                    do {
                        let result = try performingContext.fetch(fr)
                        
                        guard result.isEmpty else {
                            print("\(itemType) \(item.title) already exists")
                            return
                        }
                        
                        // Create Managed Object in child context to prProfession auto-save when app goes to background.
                        // FIXME: Switch to viewContext
                        let mo = Profession.init(context: performingContext)
                        mo.jsonId = item.jsonId
                        mo.imageName = item.imageName
                        mo.sortValue = item.sortValue
                        mo.isFavorite = item.isFavorite ?? false
                        mo.releaseStatus = item.releaseStatus ?? true
                        
                        mo.notes = item.notes
                        mo.synopsis = item.synopsis
                        mo.title = item.title
                        
                        // Relate foreign records
                        relate(profession: mo, toPersonId: item.signerId, inContext: performingContext)
                        
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

extension ProfessionImporter {
    func relate(profession:Profession, toPersonId personId:Int16?, inContext context:NSManagedObjectContext) {
        guard let personId = personId  else {
            return
        }
        
        let fr:NSFetchRequest<Person> = Person.fetchRequest()
        fr.predicate = NSPredicate(format: "jsonId == %d", personId)
        
        do {
            // Get the foreign managed object
            let fo = try context.fetch(fr).first
            fo?.addToProfessions(profession)
        }
        catch {
            DDLogError(error)
        }
    }
}
