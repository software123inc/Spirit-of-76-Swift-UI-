//
//  ThemeManager.swift
//  Spirit of 76
//
//  Created by Tim Newton on 6/11/21.
//

import UIKit

let SelectedThemeKey = "SelectedTheme"

enum Theme:String {
    case Default
    
    var mainColor:UIColor {
        switch self {
            case .Default:
                return UIColor.init(named: K.BrandColors.cayenne)!
        }
    }
}

struct ThemeManager {
    static func currentTheme() -> Theme {
        if let storedTheme = UserDefaults.standard.value(forKey: SelectedThemeKey) as? String {
            return Theme(rawValue: storedTheme)!
        } else {
            return .Default
        }
    }
    
    static func applyTheme(theme: Theme) {
        // 1
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        
        // 2
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        UINavigationBar.appearance().tintColor = theme.mainColor
        UITabBar.appearance().tintColor = theme.mainColor
    }
}
