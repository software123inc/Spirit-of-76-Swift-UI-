//
//  JWriting.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 12/30/19.
//  Copyright © 2019 Tim W. Newton. All rights reserved.
//

import Foundation

//"ID":1,
//"title":"Adams-Jefferson Letters, The",
//"synopsis":"",
//"notes":"Correspondence from 1777-1800, 1813-1826 (multiple formats).",
//"amazonLink":"https://archive.org/details/TheJefferson-adamsCorrespondence",
//"release_status":1


struct JWritings: Codable, Equatable {
    let records:[JWriting]
}

struct JWriting: Codable, Equatable {
    let id: UInt
    let title: String
    let synopsis: String?
    let notes: String
    let amazonLink: String
    let release_status: UInt
}
