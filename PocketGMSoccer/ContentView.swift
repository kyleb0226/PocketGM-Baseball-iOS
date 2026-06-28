import SwiftUI
import WebKit

/// Hosts the bundled Pocket GM web game in a full-screen WKWebView.
/// The game (index.html + vendored React/Babel/Tailwind) ships inside the app
/// bundle under `Web/`, so it runs fully offline. localStorage saves persist in
/// the app's data container across launches via the default website data store.
struct ContentView: View {
    var body: some View {
        GameWebView()
            .ignoresSafeArea(edges: .all)
            .background(Color(red: 0.043, green: 0.071, blue: 0.125)) // #0b1220
    }
}

struct GameWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        // Persist localStorage (the game's save) across app launches.
        config.websiteDataStore = .default()

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.043, green: 0.071, blue: 0.125, alpha: 1)
        webView.scrollView.backgroundColor = webView.backgroundColor
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = false

        loadGame(into: webView)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    private func loadGame(into webView: WKWebView) {
        guard let indexURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Web") else {
            let msg = "<h2 style='color:#fff;font-family:sans-serif;padding:24px'>Could not find Web/index.html in the app bundle.</h2>"
            webView.loadHTMLString(msg, baseURL: nil)
            return
        }
        // Allow read access to the whole Web/ directory so vendored scripts load.
        let webDir = indexURL.deletingLastPathComponent()
        webView.loadFileURL(indexURL, allowingReadAccessTo: webDir)
    }
}
