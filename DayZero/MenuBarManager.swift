//
//  MenuBarManager.swift
//  DayZero
//
//  Created by ufian on 12/16/24.
//

import SwiftUI
import AppKit

import SwiftUI
import AppKit

class MenuBarManager: ObservableObject {
    private var statusItem: NSStatusItem
    private var formatter: DateFormatter
    private var date: Date
    private var maxWidth: CGFloat
    private var settingsWindow: NSWindow?
    
    @AppStorage("timeFormat") private var timeFormat: String = "HH:mm:ss"
    @AppStorage("fontSize") private var fontSize: Double = 16.0

    private func startSynchronizedTimer() {
        let timer = Timer(fire: Date(), interval: 1.0, repeats: true) { _ in
            self.updateTime()
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        formatter = DateFormatter()
        date = Date()
        maxWidth = 50
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "calendar", accessibilityDescription: "MenuBar Calendar")
            button.title = " \(currentTime())"
            button.imagePosition = .imageLeading
            button.alignment = .left
        }
        
        statusItem.menu = constructMenu()
        startSynchronizedTimer()
    }

    private func updateTime() {
        if let button = statusItem.button {
            formatter.dateFormat = timeFormat
            let timeString = " \(currentTime())"
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: CGFloat(fontSize))
            ]
            
            let textWidth = (timeString as NSString).size(withAttributes: attributes).width
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
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.trailing, 8)
        
        let hostingView = NSHostingView(rootView: calView)
        
        let fittingSize = hostingView.fittingSize
        hostingView.setFrameSize(NSSize(width: fittingSize.width + 8, height: fittingSize.height + 8))

        let calendarItem = NSMenuItem()
        calendarItem.view = hostingView
        return calendarItem
    }

    private func constructMenu() -> NSMenu {
        let menu = NSMenu()
        
        let calendarItem = createCalendarMenuItem()
        menu.addItem(calendarItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let settingsItem = NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: "s")
        settingsItem.target = self
        menu.addItem(settingsItem)
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(terminate), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }
    
    @objc private func terminate() {
        NSApp.terminate(nil)
    }
    
    @objc private func openSettings() {
        if settingsWindow == nil { // Создаем окно только если его нет
            let settingsView = NSHostingController(rootView: SettingsView()) // Используем SettingsView
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 200), // Указываем размеры окна
                styleMask: [.titled, .closable, .resizable], // Стиль окна
                backing: .buffered,
                defer: false
            )
            window.title = "Settings"
            window.contentView = settingsView.view // Устанавливаем содержимое окна
            window.makeKeyAndOrderFront(nil) // Делаем окно активным
            settingsWindow = window // Сохраняем ссылку на окно
        } else {
            settingsWindow?.makeKeyAndOrderFront(nil) // Показываем существующее окно
        }
    }
}
