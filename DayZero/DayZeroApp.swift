import SwiftUI
import AppKit

struct SettingsView: View {
    @AppStorage("timeFormat") var timeFormat: String = "HH:mm:ss"
    @AppStorage("fontSize") var fontSize: Double = 16.0

    var body: some View {
        Form {
            Section() {
                TextField("Enter Time Format", text: $timeFormat)
            }
            Section() {
                Slider(value: $fontSize, in: 8...24, step: 1) {
                    Text("Font Size")
                }
                Text("Current Font Size: \(Int(fontSize))")
            }
        }
        .padding()
        .frame(width: 300)
    }
}

@main
struct DayZeroApp: App {
    @StateObject private var menuBarManager = MenuBarManager()

    var body: some Scene {
        Settings {
            SettingsView() // Используем ваш экран настроек
        }
    }
}
