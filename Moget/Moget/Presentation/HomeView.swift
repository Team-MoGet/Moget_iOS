import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}

struct HomeView: View {
    var body: some View {
        WebView(url: URL(string: "https://moget-fe.vercel.app/gacha")!)
            .ignoresSafeArea()
    }

}

#Preview {
    HomeView()
}
