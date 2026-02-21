import SwiftUI
import WebKit
import KakaoSDKShare
import KakaoSDKTemplate

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
        ZStack(alignment: .bottom) {
            WebView(url: URL(string: "https://moget-fe.vercel.app/gacha")!)
                .ignoresSafeArea()

            Button("카카오톡으로 공유 (테스트)") {
                shareToKakao()
            }
            .padding(.bottom, 40)
        }
    }

    private func shareToKakao() {
        let link = Link(
            webUrl: URL(string: "https://developers.kakao.com"),
            mobileWebUrl: URL(string: "https://developers.kakao.com")
        )

        let content = Content(
            title: "테스트 공유",
            imageUrl: URL(string: "https://mud-kage.kakao.com/dn/NTmhS/btqfEUdFAUf/FjKzkZsnoeE4o19klTOVI1/openlink_640x640s.jpg")!,
            link: link
        )

        let template = FeedTemplate(content: content)

        if ShareApi.isKakaoTalkSharingAvailable() {
            ShareApi.shared.shareDefault(templatable: template) { sharingResult, error in
                if let error = error {
                    print("카카오 공유 오류: \(error)")
                } else if let sharingResult = sharingResult {
                    UIApplication.shared.open(sharingResult.url)
                }
            }
        } else {
            print("카카오톡이 설치되어 있지 않습니다.")
        }
    }
}

#Preview {
    HomeView()
}
