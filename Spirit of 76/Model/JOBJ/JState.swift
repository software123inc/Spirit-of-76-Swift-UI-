//
//  JState.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 12/30/19.
//  Copyright © 2019 Tim W. Newton. All rights reserved.
//

import Foundation

struct JStates: Codable, Equatable {
    let records:[JState]
}

struct JState: Codable, Equatable {
    let id: UInt
    let name: String
    let img_map: String
    let abbreviation: String
}
