import SwiftUI

@main
struct PocketGMSoccerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .ignoresSafeArea()          // the web page handles its own safe-area insets
                .preferredColorScheme(.dark)
                .statusBarHidden(false)
        }
    }
}
