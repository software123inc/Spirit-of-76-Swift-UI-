//
//  TypeAliases.swift
//  Spirit of 76
//
//  Created by Tim Newton on 6/11/21.
//

import Foundation

typealias FileImportHandler = (_ fileName:String, _ keyPath:String) -> Void

// PList Importing Structure
typealias plistField = [String:Any] // Each field is a name:value pair. The name is a string, the value is any.
typealias plistRecord = [plistField] // Each record is an array of fields.
typealias plistDataSet = [String:[plistRecord]] // Each plist file has a single data set. The data set has a string called "records" which contains an array of plistRecords
typealias plistDataSetToManagedObjectTransformerClosure = (Codable) -> Void
