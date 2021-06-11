//
//  JSigner.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 12/30/19.
//  Copyright © 2019 Tim W. Newton. All rights reserved.
//

import Foundation

struct JSigners: Codable, Equatable {
    let records:[JSigner]
}

struct JSignerEducations: Codable, Equatable {
    let records:[JSignerEducation]
}

struct JSignerFacts: Codable, Equatable {
    let records:[JSignerFact]
}

struct JSignerProfessions: Codable, Equatable {
    let records:[JSignerProfession]
}

struct JSignerWritings: Codable, Equatable {
    let records:[JSignerWriting]
}

struct JSigner: Codable, Equatable {
    let id: UInt
    let dateModified: String
    let firstName: String
    let middleName: String?
    let lastName: String
    let namePrefix: String?
    let nameSuffix: String?
    let title: String?
    let dateOfBirth: String
    let dateOfDeath: String
    let birthCountryId: UInt
    let birthStateId: UInt
    let residenceStateId: UInt
    let img_icon: String
    let img_portrait: String
    let descriptiveText: String
    let biography: String
    let placeOfBirth: String
    let placeOfDeath: String
    let signerDOI: String
    let signerUSC: String
    let release_status: UInt
}

struct JSignerEducation: Codable, Equatable {
    let id: UInt
    let signerID: UInt
    let title: String
    let notes: String
}

struct JSignerFact: Codable, Equatable {
    let id: UInt
    let signerID: UInt
    let synopsis: String?
    let notes: String
}

struct JSignerProfession: Codable, Equatable {
    let id: UInt
    let signerID: UInt
    let synopsis: String?
    let title: String
    let notes: String
}

struct JSignerWriting: Codable, Equatable {
    let id: UInt
    let signerID: UInt
    let writingID: UInt
}
