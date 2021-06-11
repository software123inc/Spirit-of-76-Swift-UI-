//
//  JEvent.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 12/30/19.
//  Copyright © 2019 Tim W. Newton. All rights reserved.
//

import Foundation

struct JEvents: Codable, Equatable {
    let records:[JEvent]
}

struct JEvent: Codable, Equatable {
    let id: UInt
    let name: String
    let year: UInt
    let asOfDate: String
    let synopsis: String
    let notes: String
    let endDate: String?
    let endYear: UInt?
    let release_status: UInt
}
