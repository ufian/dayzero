import SwiftUI
import AppKit

@main
struct DayZeroApp: App {
    @StateObject private var menuBarManager = MenuBarManager()

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
