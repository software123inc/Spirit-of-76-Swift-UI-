//
//  PListImporter.swift
//  Spirit of 76
//
//  Created by Tim Newton on 6/11/21.
//

import CoreData
import Foundation
import S123Common
import CocoaLumberjackSwift

struct PListImporter {
    static let shared = PListImporter()
    
    func itemList(forResource resource:String, root:String) -> plistRecord? {
        guard let path = Bundle.main.path(forResource: resource, ofType: "plist") else {
            DDLogWarn("\(resource) - Could not open plist file '\(resource)'.")
            return nil
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            guard let plistData = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? plistField else {
                DDLogWarn("\(resource) - Could not serialize plist file '\(resource)'.")
                return nil
            }
            
            guard let itemList = plistData[root] as? plistRecord else {
                DDLogWarn("\(resource) - Items are not formatted as expected.")
                return nil
            }
            
            return itemList
        }
        catch {
            DDLogError(error.localizedDescription)
            return nil
        }
    }
}
