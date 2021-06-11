//
//  JTopic.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 12/30/19.
//  Copyright © 2019 Tim W. Newton. All rights reserved.
//

import Foundation

struct JTopics: Codable, Equatable {
    let records:[JTopic]
}

struct JTopic: Codable, Equatable {
    let id: UInt
    let title: String
    let synopsis: String
    let notes: String?
}
