//
//  JCountry.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 12/30/19.
//  Copyright © 2019 Tim W. Newton. All rights reserved.
//

import Foundation

struct JCountries: Codable, Equatable {
    let records:[JCountry]
}

struct JCountry: Codable, Equatable {
    let id: UInt
    let name: String
    let img_flag: String
}
