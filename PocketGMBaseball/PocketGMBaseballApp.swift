import SwiftUI

@main
struct PocketGMBaseballApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .ignoresSafeArea()          // the web page handles its own safe-area insets
                .preferredColorScheme(.dark)
                .statusBarHidden(false)
        }
    }
}
