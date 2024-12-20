//
//  MenuBarManager.swift
//  DayZero
//
//  Created by ufian on 12/16/24.
//

import SwiftUI
import AppKit

class MenuBarManager: ObservableObject {
    private var statusItem: NSStatusItem
    private var formatter: DateFormatter
    private var date: Date
    private var maxWidth: CGFloat

    private func startSynchronizedTimer() {
        let timer = Timer(fire: Date(), interval: 1.0, repeats: true) { _ in
            self.updateTime()
        }
        // Add timer to the main run loop
        RunLoop.main.add(timer, forMode: .common)
    }
    
    init() {
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        date = Date()
        maxWidth = 50;

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "calendar", accessibilityDescription: "MenuBar Calendar")
            button.title = " \(currentTime())"
            button.imagePosition = .imageLeading
            button.alignment = .left
        }

        // Menu configuration
        statusItem.menu = constructMenu()

        // Start synchronized timer
        startSynchronizedTimer()
    }

    // Function to time update
    private func updateTime() {
        if let button = statusItem.button {
            let timeString = " \(currentTime())";
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 16)
            ]
            
            let textWidth = (timeString as NSString).size(withAttributes: attributes).width
            
            let iconWidth: CGFloat = button.image?.size.width ?? 0
            maxWidth = max(maxWidth, textWidth)
            
            statusItem.length = maxWidth + 24
            
            let attributedString = NSAttributedString(string: " \(timeString)", attributes: attributes)
            button.attributedTitle = attributedString
            button.alignment = .left
        }
    }

    private func currentTime() -> String {
        date = Date()
        return formatter.string(from: date)
    }
    
    private func createCalendarMenuItem() -> NSMenuItem {
        let calView = CalendarView()
        let hostingView = NSHostingView(rootView: calView)
        
        let fittingSize = hostingView.fittingSize
        hostingView.setFrameSize(fittingSize)

        let calendarItem = NSMenuItem()
        calendarItem.view = hostingView
        return calendarItem
    }

    private func constructMenu() -> NSMenu {
        let menu = NSMenu()
        
        let calendarItem = createCalendarMenuItem()
        menu.addItem(calendarItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(terminate), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }
    
    @objc private func terminate() {
        NSApp.terminate(nil)
    }
}
