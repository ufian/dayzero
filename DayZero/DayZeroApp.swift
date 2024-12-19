import SwiftUI
import AppKit

@main
struct DayZeroApp: App {
    @StateObject private var menuBarManager = MenuBarManager()

    var body: some Scene {
        Settings {
            EmptyView() // Главное окно не требуется
        }
    }
}
/*
class MenuBarManager: ObservableObject {
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var timer: Timer?

    init() {
        // Создаем статус-бар элемент
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        // Настраиваем popover для календаря
        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 350)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: CalendarView())

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "calendar", accessibilityDescription: "Calendar")
            button.action = #selector(togglePopover)
            button.target = self
            button.imagePosition = NSControl.ImagePosition.imageLeading
            updateTime() // Устанавливаем текущее время
        }

        // Таймер для обновления времени каждую секунду
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTime()
        }
    }

    // Обновление времени в менюбаре
    private func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss" // Формат времени
        let currentTime = formatter.string(from: Date())

        if let button = statusItem.button {
            button.title = " \(currentTime)"
        }
    }

    // Открытие/закрытие календаря
    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
            popover.contentViewController?.view.window?.becomeKey()
        }
    }
}
*/
