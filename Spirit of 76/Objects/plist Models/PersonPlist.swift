//
//  PersonPlist.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/11/21.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

struct PersonPlist: Codable {
    let jsonId:Int16
    let sortValue:String?
    let imageName:String?
    let isFavorite:Bool?
    let releaseStatus:Bool?
    
    let dateOfBirth:String?
    let dateOfDeath:String?
    let descriptiveText:String?
    let firstName:String
    let lastName:String
    let middleName:String?
    let namePrefix:String?
    let nameSuffix:String?
    let placeOfBirth:String?
    let placeOfDeath:String?
    let signerDOI:Bool
    let signerUSC:Bool
    let summaryText:String?
    let title:String?
    
    // Foreign Keys
    let birthCountryId:Int16?
    let birthStateId:Int16?
    let residenceStateId:Int16?
}

struct PersonImporter {
    static let shared = PersonImporter()
    let itemType = "Person"
    
    func doImport_v1(inContext performingContext: NSManagedObjectContext) {
        let udKey = UserDefaultKeys.plist_persons_v1
        
        if !UserDefaults.standard.contains(key:udKey) || !UserDefaults.standard.bool(forKey: udKey) {
            DDLogInfo("Importing \(itemType)s v1.")
            let resourceName = "\(itemType)s_v1".lowercased()
            if let plistItems = PListImporter.shared.itemList(forResource: resourceName, root: "records") {
                var transformSuccess = true
                PListSeeder.shared.transformPListRecords(plistItems, ofType:PersonPlist.self) { item in
                    guard let item = item as? PersonPlist else {
                        DDLogWarn("item does not conform to \(itemType)Plist")
                        transformSuccess = false
                        return
                    }
                    
                    let fr:NSFetchRequest<Person> = Person.fetchRequest()
                    fr.predicate = NSPredicate(format: "jsonId == %d", item.jsonId)
                    
                    do {
                        let result = try performingContext.fetch(fr)
                        
                        guard result.isEmpty else {
                            print("\(itemType) \(item.lastName) already exists")
                            return
                        }
                        
                        // Create Managed Object in child context to prPerson auto-save when app goes to background.
                        // FIXME: Switch to viewContext
                        let mo = Person.init(context: performingContext)
                        mo.jsonId = item.jsonId
                        mo.imageName = item.imageName
                        mo.sortValue = item.sortValue
                        mo.isFavorite = item.isFavorite ?? false
                        mo.releaseStatus = item.releaseStatus ?? true
                        
                        mo.dateOfBirth = PListSeeder.shared.date(fromString: item.dateOfBirth)
                        mo.dateOfDeath = PListSeeder.shared.date(fromString: item.dateOfDeath)
                        mo.descriptiveText = item.descriptiveText
                        mo.firstName = item.firstName
                        mo.lastName = item.lastName
                        mo.middleName = item.middleName
                        mo.namePrefix = item.namePrefix
                        mo.nameSuffix = item.nameSuffix
                        mo.placeOfBirth = item.placeOfBirth
                        mo.placeOfDeath = item.placeOfDeath
                        mo.signerDOI = item.signerDOI
                        mo.signerUSC = item.signerUSC
                        mo.summaryText = item.summaryText
                        mo.title = item.title
                        
                        PersistenceController.saveContext(context: performingContext)
                        DDLogDebug("Created \(itemType) '\(String(describing: mo.firstName)) \(String(describing: mo.lastName))'.")
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




