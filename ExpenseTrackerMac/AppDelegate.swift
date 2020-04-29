//
//  AppDelegate.swift
//  ExpenseTrackerMac
//
//  Created by Alfian Losari on 27/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    var coreDataStack = CoreDataStack(modelName: "ExpenseTracker")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        coreDataStack.viewContext.automaticallyMergesChangesFromParent = true
        
        let contentView = ContentView()
            .environment(\.managedObjectContext, coreDataStack.viewContext)
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.titlebarAppearsTransparent = true
        window.center()
        window.title = "Expense Tracker"
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
    
}

