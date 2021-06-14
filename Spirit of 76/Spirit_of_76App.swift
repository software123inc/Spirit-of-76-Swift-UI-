//
//  Spirit_of_76App.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/10/21.
//

import SwiftUI
import S123Common
import CocoaLumberjackSwift

@main
struct Spirit_of_76App: App {
    @Environment(\.scenePhase) private var scenePhase
    let persistenceController = PersistenceController.shared
    
    private var hasOnboarded: Bool
    
    init() {
        S123Common.activateLogging()
        
        let defaults = UserDefaults.standard
        hasOnboarded = defaults.bool(forKey: "hasOnboarded")
        
        if !hasOnboarded {
            defaults.setValue(true, forKey: "hasOnboarded")
            DDLogDebug("First Launch.")
        }
        else {
            DDLogDebug("Subsequent Launch.")
        }
        
        PListSeeder.shared.getSeedFilesAndImport()
        ThemeManager.applyTheme(theme: .Default)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
                case .active:
                    doAppIsActiveTasks()
                case .background:
                    doEnterBackgroundTasks()
                case .inactive:
                    // The scene is in the foreground but should pause its work.
                    doAppIsInactiveTasks()
                @unknown default:
                    DDLogWarn("App entering unhandled scene phase.")
            }
        }
    }
}

extension Spirit_of_76App {
    func saveChanges() {
        do {
            if persistenceController.container.viewContext.hasChanges {
                try persistenceController.container.viewContext.save()
            }
        } catch {
            DDLogError(error.localizedDescription)
        }
    }
    
    private func doAppIsActiveTasks() {
        DDLogVerbose("App entering active phase.")
    }
    
    private func doEnterBackgroundTasks() {
        DDLogVerbose("App entering background phase.")
        saveChanges()
    }
    
    private func doAppIsInactiveTasks() {
        DDLogVerbose("App entering inactive phase.")
        saveChanges()
    }
    
    private func initializeUserDefaults() {
        let ud = UserDefaults.standard
        
        if !ud.contains(key: K.PrefKey.scrollMiniTextViews) {
            ud.set(true, forKey: K.PrefKey.scrollMiniTextViews)
        }
        
        if !ud.contains(key: K.PrefKey.showTablesInitially) {
            ud.set(true, forKey: K.PrefKey.showTablesInitially)
        }
    }
}
