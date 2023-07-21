import SwiftUI

@main
struct FootballScorePredictorApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .defaultSize(width: 600, height: 500)
        #endif
    }

}
