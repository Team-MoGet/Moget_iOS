import SwiftUI
import WebKit
import KakaoSDKShare
import KakaoSDKTemplate

struct WebView: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.userContentController.add(context.coordinator, name: "kakaoShare")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.navigationDelegate = context.coordinator
        print("[WebView] kakaoShare 핸들러 등록 완료")
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }

    class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let js = "typeof window.webkit !== 'undefined' && typeof window.webkit.messageHandlers !== 'undefined' && typeof window.webkit.messageHandlers.kakaoShare !== 'undefined'"
            webView.evaluateJavaScript(js) { result, _ in
                print("[WebView] JS에서 kakaoShare 핸들러 접근 가능: \(result ?? "nil")")
            }
        }
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("[WebView] 메시지 수신: \(message.name)")
            guard message.name == "kakaoShare" else { return }
            print("[WebView] kakaoShare 메시지 확인 → 공유 실행")
            shareToKakao()
        }

        private func shareToKakao() {
            let link = Link(
                webUrl: URL(string: "https://moget-fe.vercel.app/gacha"),
                mobileWebUrl: URL(string: "https://moget-fe.vercel.app/gacha")
            )
            let content = Content(
                title: "눌러서 생일선물 받기",
                imageUrl: URL(string: "https://legislative-gold-kugsu5bx3s.edgeone.app/카카오.png")!,
                link: link
            )
            let template = FeedTemplate(content: content)

            print("[Kakao] 카카오톡 설치 여부: \(ShareApi.isKakaoTalkSharingAvailable())")
            if ShareApi.isKakaoTalkSharingAvailable() {
                ShareApi.shared.shareDefault(templatable: template) { sharingResult, error in
                    if let error = error {
                        print("[Kakao] 공유 오류: \(error)")
                    } else if let sharingResult = sharingResult {
                        print("[Kakao] 공유 성공, URL 오픈")
                        UIApplication.shared.open(sharingResult.url)
                    }
                }
            } else {
                print("[Kakao] 카카오톡 미설치")
            }
        }
    }
}

struct HomeView: View {
    var body: some View {
        WebView(url: URL(string: "https://moget-fe.vercel.app/gacha")!)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
    }
}

#Preview {
    HomeView()
}
