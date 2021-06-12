//
//  EducationPlist.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/11/21.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

struct EducationPlist: Codable {
    let jsonId:Int16
    let sortValue:String?
    let imageName:String?
    let isFavorite:Bool?
    let releaseStatus:Bool?
    
    let notes:String
    let title:String
    let signerId:Int16?
}

struct EducationImporter {
    static let shared = EducationImporter()
    let itemType = "Education"
    
    func doImport_v1(inContext performingContext: NSManagedObjectContext) {
        let udKey = UserDefaultKeys.plist_education_v1
        
        if !UserDefaults.standard.contains(key:udKey) || !UserDefaults.standard.bool(forKey: udKey) {
            DDLogVerbose("Importing \(itemType)s v1.")
            let resourceName = "\(itemType)_v1".lowercased()
            if let plistItems = PListImporter.shared.itemList(forResource: resourceName, root: "records") {
                var transformSuccess = true
                PListSeeder.shared.transformPListRecords(plistItems, ofType:EducationPlist.self) { item in
                    guard let item = item as? EducationPlist else {
                        DDLogWarn("item does not conform to \(itemType)Plist")
                        transformSuccess = false
                        return
                    }
                    
                    let fr:NSFetchRequest<Education> = Education.fetchRequest()
                    fr.predicate = NSPredicate(format: "jsonId == %d", item.jsonId)
                    
                    do {
                        let result = try performingContext.fetch(fr)
                        
                        guard result.isEmpty else {
                            print("\(itemType) \(item.jsonId) already exists")
                            return
                        }
                        
                        // Create Managed Object in child context to prEducation auto-save when app goes to background.
                        // FIXME: Switch to viewContext
                        let mo = Education.init(context: performingContext)
                        mo.jsonId = item.jsonId
                        mo.imageName = item.imageName
                        mo.sortValue = item.sortValue
                        mo.isFavorite = item.isFavorite ?? false
                        mo.releaseStatus = item.releaseStatus ?? true
                        
                        mo.notes = item.notes
                        mo.title = item.title
                        
                        relate(education: mo, toPersonId: item.signerId, inContext: performingContext)
                        
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
            DDLogVerbose("Bypass Importing \(itemType)s v1.")
        }
    }
}

extension EducationImporter {
    func relate(education:Education, toPersonId personId:Int16?, inContext context:NSManagedObjectContext) {
        guard let personId = personId  else {
            return
        }
        
        let fr:NSFetchRequest<Person> = Person.fetchRequest()
        fr.predicate = NSPredicate(format: "jsonId == %d", personId)
        
        do {
            // Get the foreign managed object
            let fo = try context.fetch(fr).first
            fo?.addToEducations(education)
        }
        catch {
            DDLogError(error)
        }
    }
}
