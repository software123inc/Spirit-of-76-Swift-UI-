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
        StatesImporter.shared.ConfirmStatesAreImported(inContext: performingContext)
        
        if !UserDefaults.standard.contains(key:udKey) || !UserDefaults.standard.bool(forKey: udKey) {
            DDLogVerbose("Importing \(itemType)s v1.")
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
                            DDLogWarn("\(itemType) \(item.lastName) already exists")
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
                        
                        // Relate records
                        relate(person: mo, toBirthCountryId: item.birthCountryId, inContext: performingContext)
                        relate(person: mo, toBirthStateId: item.birthStateId, inContext: performingContext)
                        relate(person: mo, toResidentStateId: item.residenceStateId, inContext: performingContext)
                        
                        PersistenceController.saveContext(context: performingContext)
                        DDLogVerbose("Created \(itemType) '\(String(describing: mo.firstName)) \(String(describing: mo.lastName))'.")
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
    
    func sync_states(inContext performingContext: NSManagedObjectContext) {
        DDLogVerbose("Resyncing Person:States from \(itemType)s_v1.")
        let resourceName = "\(itemType)s_v1".lowercased()
        if let plistItems = PListImporter.shared.itemList(forResource: resourceName, root: "records") {
            PListSeeder.shared.transformPListRecords(plistItems, ofType:PersonPlist.self) { item in
                guard let item = item as? PersonPlist else {
                    DDLogWarn("item does not conform to \(itemType)Plist")
                    return
                }
                
                let fr:NSFetchRequest<Person> = Person.fetchRequest()
                fr.predicate = NSPredicate(format: "jsonId == %d", item.jsonId)
                
                do {
                    let results = try performingContext.fetch(fr)
                    
                    guard !results.isEmpty, let person = results.first else {
                        DDLogWarn("\(itemType) \(item.lastName) not found.")
                        return
                    }
                    
                    // Relate records
                    relate(person: person, toBirthCountryId: item.birthCountryId, inContext: performingContext)
                    relate(person: person, toBirthStateId: item.birthStateId, inContext: performingContext)
                    relate(person: person, toResidentStateId: item.residenceStateId, inContext: performingContext)
                    
                    PersistenceController.saveContext(context: performingContext)
                    DDLogVerbose("Updated \(String(describing: person.firstName)) \(String(describing: person.lastName))'.")
                }
                catch {
                    DDLogError(error)
                }
                
                PersistenceController.saveContext(context: performingContext)
            }
        }
        else {
            DDLogWarn("Could not load \(resourceName)")
        }
    }
}

extension PersonImporter {    
    func relate(person:Person, toBirthCountryId countryId:Int16?, inContext context:NSManagedObjectContext) {
        guard let countryId = countryId  else {
            return
        }
        
        let fr:NSFetchRequest<Country> = Country.fetchRequest()
        fr.predicate = NSPredicate(format: "jsonId == %d", countryId)
        
        do {
            // Get the foreign managed object
            let fo = try context.fetch(fr).first
            fo?.addToBirthPersons(person)
        }
        catch {
            DDLogError(error)
        }
    }
    
    func relate(person:Person, toBirthStateId stateId:Int16?, inContext context:NSManagedObjectContext) {
        guard let stateId = stateId  else {
            return
        }
        
        let fr:NSFetchRequest<States> = States.fetchRequest()
        fr.predicate = NSPredicate(format: "jsonId == %d", stateId)
        
        do {
            // Get the foreign managed object
            let fo = try context.fetch(fr).first
            fo?.addToBirthPersons(person)
        }
        catch {
            DDLogError(error)
        }
    }
    
    func relate(person:Person, toResidentStateId stateId:Int16?, inContext context:NSManagedObjectContext) {
        guard let stateId = stateId  else {
            DDLogWarn("\(person.firstName ?? "") \(person.lastName ?? "") has no resident state.")
            return
        }
        
        let fr:NSFetchRequest<States> = States.fetchRequest()
        fr.predicate = NSPredicate(format: "jsonId == %d", stateId)
        
        do {
            // Get the foreign managed object
            let results = try context.fetch(fr)
            guard results.count > 0 else {
                DDLogWarn("Resident state with ID \(stateId) not found.")
                return
            }
            
            let fo = results.first
            fo?.addToResidentPersons(person)
            DDLogDebug("\(person.firstName ?? "*") \(person.lastName ?? "*") has resident state '\(fo?.name ?? "*")', image name '\(fo?.imageName ?? "*")'.")
        }
        catch {
            DDLogError(error)
        }
    }
}
