//
//  Constants.swift
//  Spirit of 76
//
//  Created by Tim Newton on 6/11/21.
//

import UIKit
import SwiftUI

struct K {
    static let appName = "Spirit of '76"
    static let appURL = URL(string: "https://apps.apple.com/us/app/id441447292")
    static let foundingDocsAppURL = URL(string: "https://apps.apple.com/us/app/id441447292")
    //    static let facebookURL = URL(string: "https://www.facebook.com/spirit76app")!
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    
    struct PrefKey {
        static let scrollMiniTextViews = "scrollMiniTextViews"
        static let showTablesInitially = "showTablesInitially"
    }
    
    struct UIImages {
        static let declarationBlurredBkgnd = UIImage(named: "declaration_pale_blurred")
        static let fife_and_drum = UIImage(named: "Fife_and_Drum")
        static let libertyBell = UIImage(named: "LibertyBell")
        static let star = UIImage(systemName: "star")
        static let star_filled = UIImage(systemName: "star.fill")
    }
    
    struct ImageView {
        static let libertyBell = UIImageView.init(image: K.UIImages.libertyBell)
    }
    
    struct Images {
        static let fife_and_drum = Image(uiImage: K.UIImages.fife_and_drum!)
    }
    
    struct BrandColors {
        static let cayenne = "BrandCayenne"
    }
    
    struct ManObjKey {
        static let asOfDate = "asOfDate"
        static let entity = "entity"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let name = "name"
        static let sortValue = "sortValue"
        static let quotation = "quotation"
        static let title = "title"
        static let year = "year"
    }
    
    struct SortBy {
        static let asOfDateASC = NSSortDescriptor(key: K.ManObjKey.asOfDate, ascending: true)
        static let entityASC = NSSortDescriptor(key: K.ManObjKey.entity, ascending: true)
        static let nameASC = NSSortDescriptor(key: K.ManObjKey.name, ascending: true)
        static let quotationASC = NSSortDescriptor(key: K.ManObjKey.quotation, ascending: true)
        static let sortValueASC = NSSortDescriptor(key: K.ManObjKey.sortValue, ascending: true)
        static let titleASC = NSSortDescriptor(key: K.ManObjKey.title, ascending: true)
        static let yearASC = NSSortDescriptor(key: K.ManObjKey.year, ascending: true)
        static let lastFirstASC = [NSSortDescriptor(key: K.ManObjKey.lastName, ascending: true), NSSortDescriptor(key: K.ManObjKey.firstName, ascending: true)]
    }
    
    struct Predicate {
        static let isFavorite = NSPredicate.init(format: "isFavorite == true")
        static let isReleased = NSPredicate.init(format: "releaseStatus == true")
    }
}
