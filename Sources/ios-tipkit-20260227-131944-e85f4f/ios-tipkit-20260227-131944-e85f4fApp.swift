import SwiftUI
import TipKit

@main
struct TipKitDemoApp: App {
    init() {
        do {
            try Tips.configure([
                .displayFrequency(.immediate)
            ])
        } catch {
            print("TipKit configuration failed: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
