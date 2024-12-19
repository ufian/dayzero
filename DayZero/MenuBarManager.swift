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

    init() {
        // Создаем элемент статус-бара
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        date = Date()

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "calendar", accessibilityDescription: "MenuBar Calendar")
            button.title = " \(currentTime())"
            button.imagePosition = .imageLeading
        }

        // Настраиваем меню
        statusItem.menu = constructMenu()

        // Таймер для обновления времени каждую секунду
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTime()
        }
    }

    // Функция обновления времени
    private func updateTime() {
        if let button = statusItem.button {
            button.title = " \(currentTime())"
        }
    }

    private func currentTime() -> String {
        date = Date()
        return formatter.string(from: date)
    }
    
    private func createCalendarMenuItem() -> NSMenuItem {
        // Создаем SwiftUI View
        var calView = CalendarView()

        // Оборачиваем SwiftUI View в NSHostingView
        let hostingView = NSHostingView(rootView: calView)
//        hostingView.translatesAutoresizingMaskIntoConstraints = false
        //hostingView.wantsLayer = true
//        hostingView.layer?.borderWidth = 0 // Убедимся, что границы нет
        //hostingView.layer?.backgroundColor = NSColor.clear.cgColor
//        hostingView.focusRingType = .none
//        hostingView.window?.makeFirstResponder(nil) // Снимаем фокус с представления

        let fittingSize = hostingView.fittingSize
        hostingView.setFrameSize(fittingSize)

        // Добавляем NSHostingView в NSMenuItem
        var calendarItem = NSMenuItem()
        calendarItem.view = hostingView
        


        print("Calendar size - Width: \(fittingSize.width), Height: \(fittingSize.height)")
        return calendarItem
    }
    // Конструирование меню с календарем
    private func constructMenu() -> NSMenu {
        let menu = NSMenu()
        
        // Добавляем календарь
        let calendarItem = createCalendarMenuItem()
        menu.addItem(calendarItem)
        
        // Разделитель
        menu.addItem(NSMenuItem.separator())
        
        // Кнопка "Quit"
        let quitItem = NSMenuItem(title: "Quit", action: #selector(terminate), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }
    
    @objc private func terminate() {
        NSApp.terminate(nil)
    }
}
