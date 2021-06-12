//
//  AuthorshipPlist.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/11/21.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

struct AuthorshipPlist: Codable {
    let jsonId:Int16
    let personId:Int16?
    let writingId:Int16
}

struct AuthorshipImporter {
    static let shared = AuthorshipImporter()
    let itemType = "Authorship"
    
    func doImport_v1(inContext performingContext: NSManagedObjectContext) {
        let udKey = UserDefaultKeys.plist_authorships_v1
        
        if !UserDefaults.standard.contains(key:udKey) || !UserDefaults.standard.bool(forKey: udKey) {
            DDLogInfo("Importing \(itemType)s v1.")
            let resourceName = "\(itemType)s_v1".lowercased()
            if let plistItems = PListImporter.shared.itemList(forResource: resourceName, root: "records") {
                var transformSuccess = false
                PListSeeder.shared.transformPListRecords(plistItems, ofType:AuthorshipPlist.self) { item in
                    guard let _ = item as? AuthorshipPlist else {
                        DDLogWarn("item does not conform to \(itemType)Plist")
                        transformSuccess = false
                        return
                    }
                    
                    
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



