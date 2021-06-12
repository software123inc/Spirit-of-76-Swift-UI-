//
//  JSONHelper.swift
//  Spirit of 76
//
//  Created by Tim Newton on 6/11/21.
//

import SwiftUI
import CoreData
import CocoaLumberjackSwift
import SwiftyJSON
import S123Common

struct JSONHelper {
    static let shared = JSONHelper()
    
    @Environment(\.managedObjectContext) private static var viewContext
    private let files = Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil).sorted()
    
    private let rootDataImportHandler: FileImportHandler = { filename, keyPath in
        if let f = RootFiles.init(rawValue: filename) {
            switch f {
                case .countries:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Country.self)
                        DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                        UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                    }
                default:
                    DDLogWarn("Unhandled filename: \(filename)")
            }
        }
    }
    
    private let tier2ImportHandler: FileImportHandler = { filename, keyPath in
    }
    
    private let tier3ImportHandler: FileImportHandler = { filename, keyPath in
    }
    
    private let tier4ImportHandler: FileImportHandler = { filename, keyPath in
    }
    
    private func importData(handler:FileImportHandler) {
        for file in files {
            let filename = file.lastPathComponenSansExtension
            let keyPath = "JSONManager_\(filename)"
            let needsImport = !UserDefaults.standard.bool(forKey: keyPath)
            
            if needsImport {
                handler(filename, keyPath)
            }
        }
    }
    
    func importSeedData() {
        importData(handler: rootDataImportHandler)
        importData(handler: tier2ImportHandler)
        importData(handler: tier3ImportHandler)
        importData(handler: tier4ImportHandler)
    }
    
    private func manObj<T:NSManagedObject>(_ type:T.Type, havingJsonId jsonId:Int16) -> T? {
        var results:[T]?
        let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        let predicate = NSPredicate(format: "jsonId == %i", jsonId)
        
        request.predicate = predicate
        
        do {
            results = try JSONHelper.viewContext.fetch(request)
        }
        catch {
            DDLogError(error.localizedDescription)
        }
        
        return results?.first
    }
}

extension JSONHelper {
    private func city(havingJsonId jsonId:Int16) -> City? {
        var results:[City]?
        let request: NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "jsonId == %i", jsonId)
        
        request.predicate = predicate
        
        do {
            results = try JSONHelper.viewContext.fetch(request)
            
            if let result = results?.first {
                return result
            }
        }
        catch {
            DDLogError(error.localizedDescription)
        }
        
        return nil
    }
}

fileprivate enum RootFiles:String {
    case
        countries,
        events,
        states,
        topics,
        writings
}

fileprivate enum Tier2Files:String {
    case cities,
         signers
}

fileprivate enum Tier3Files:String {
    case signerEducation,
         signerFacts,
         signerProfessions,
         signerWritings
}

fileprivate enum Tier4Files:String {
    case quotes
}
