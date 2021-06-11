//
//  JCity.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 12/30/19.
//  Copyright © 2019 Tim W. Newton. All rights reserved.
//

import Foundation

struct JCities: Codable, Equatable {
    let records:[JCity]
}

struct JCity: Codable, Equatable {
    let id: UInt
    let name: String
    let img_portrait: String?
    let synopsis: String?
    let notes: String?
    let stateID: UInt
    let countryID: UInt?
}
