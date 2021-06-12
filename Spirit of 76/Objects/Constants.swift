//
//  Constants.swift
//  Spirit of 76
//
//  Created by Tim Newton on 6/11/21.
//

import UIKit

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
    
    struct Image {
        static let declarationBlurredBkgnd = UIImage(named: "declaration_pale_blurred")
        static let fife_and_drum = UIImage.init(named: "Fife_and_Drum")
        static let libertyBell = UIImage.init(named: "LibertyBell")
        static let star = UIImage.init(systemName: "star")
        static let star_filled = UIImage.init(systemName: "star.fill")
    }
    
    struct ImageView {
        static let libertyBell = UIImageView.init(image: K.Image.libertyBell)
    }
    
    struct BrandColors {
        static let cayenne = "BrandCayenne"
    }
    
    struct ManObjKey {
        static let asOfDate = "asOfDate"
        static let entity = "entity"
        static let sortValue = "sortValue"
        static let year = "year"
    }
    
    struct SortBy {
        static let asOfDateASC = NSSortDescriptor(key: K.ManObjKey.asOfDate, ascending: true)
        static let entityASC = NSSortDescriptor(key: K.ManObjKey.entity, ascending: true)
        static let sortValueASC = NSSortDescriptor(key: K.ManObjKey.sortValue, ascending: true)
        static let yearASC = NSSortDescriptor(key: K.ManObjKey.year, ascending: true)
    }
    
    struct Predicate {
        static let isFavorite = NSPredicate.init(format: "isFavorite == true")
        static let isReleased = NSPredicate.init(format: "releaseStatus == true")
    }
    
    struct CacheName {
        static let eventsCache = "eventsCache"
        static let personCache = "personCache"
        static let topicCache = "topicCache"
    }
    
    struct SegueID {
        static let showAboutDetails = "showAboutDetails"
        static let showPersonDetail = "showPersonDetail"
        static let showEventDetail = "showEventDetail"
        static let showTopicDetail = "showTopicDetail"
        static let showEducation = "showEducation"
        static let showFavoriteDetail = "showFavoriteDetail"
        static let showFacts = "showFacts"
        static let showProfessions = "showProfessions"
        static let showQuotes = "showQuotes"
        static let addCardSummaryContent = "addCardSummaryContent"
        static let moreDetailTextPopover = "moreDetailTextPopover"
        static let showFavoriteSigner = "showFavoriteSigner"
        static let showFavoriteEvent = "showFavoriteEvent"
        static let showFavoriteTopic = "showFavoriteTopic"
    }
    
    struct TVCIdentifier {
        static let aboutCell = "AboutCell"
        static let eventCell = "EventCell"
        static let personCell = "PersonCell"
        static let topicCell = "TopicCell"
        static let favoriteCell = "FavoriteCell"
    }
    
    struct ViewControllerID {
        static let cardSummaryContent = "CardSummaryContent"
    }
}

typealias Section = SectionType
enum SectionType {
    case main
}

typealias FavoriteSection = FavoriteSectionType
enum FavoriteSectionType: Int, CaseIterable {
    case education = 0, event, fact, person, profession, quote, topic, documents
    
    func description() -> String {
        switch self {
            case .documents:
                return "Documents"
            case .education:
                return "Education"
            case .event:
                return "Events"
            case .fact:
                return "Facts"
            case .person:
                return "Signers"
            case .profession:
                return "Professions"
            case .quote:
                return "Quotes"
            case .topic:
                return "Topics"
        }
    }
    
    static func typeFromSectionName(_ sectionName:FavoriteSectionEntityNames) -> FavoriteSectionType {
        switch sectionName {
            case .documents: return .documents
            case .education: return .education
            case .event: return .event
            case .fact: return .fact
            case .person: return .person
            case .profession: return .profession
            case .quote: return .quote
            case .topic: return .topic
        }
    }
}

enum FavoriteSectionEntityNames: String, CaseIterable {
    case documents = "Documents"
    case education = "Education"
    case event = "Event"
    case fact = "Fact"
    case person = "Person"
    case profession = "Profession"
    case quote = "Quote"
    case topic = "Topic"
    
    func description() -> String {
        switch self {
            case .documents:
                return "Documents"
            case .education:
                return "Education"
            case .event:
                return "Events"
            case .fact:
                return "Facts"
            case .person:
                return "Signers"
            case .profession:
                return "Professions"
            case .quote:
                return "Quotes"
            case .topic:
                return "Topics"
        }
    }
}

