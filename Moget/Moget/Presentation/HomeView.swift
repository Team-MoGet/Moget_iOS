import SwiftUI
import WebKit
import KakaoSDKShare
import KakaoSDKTemplate
import AVKit

struct WebView: UIViewRepresentable {
    let url: URL
    var onShowVideo: () -> Void = {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onShowVideo: onShowVideo)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.userContentController.add(context.coordinator, name: "kakaoShare")
        config.userContentController.add(context.coordinator, name: "showVideo")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.navigationDelegate = context.coordinator
        print("[WebView] 핸들러 등록 완료 (kakaoShare, showVideo)")
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }

    class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        var onShowVideo: () -> Void

        init(onShowVideo: @escaping () -> Void) {
            self.onShowVideo = onShowVideo
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let js = "typeof window.webkit !== 'undefined' && typeof window.webkit.messageHandlers !== 'undefined' && typeof window.webkit.messageHandlers.kakaoShare !== 'undefined'"
            webView.evaluateJavaScript(js) { result, _ in
                print("[WebView] JS에서 kakaoShare 핸들러 접근 가능: \(result ?? "nil")")
            }
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("[WebView] 메시지 수신: \(message.name)")
            switch message.name {
            case "kakaoShare":
                print("[WebView] kakaoShare 메시지 확인 → 공유 실행")
                shareToKakao()
            case "showVideo":
                print("[WebView] showVideo 메시지 확인 → 영상 재생")
                DispatchQueue.main.async { self.onShowVideo() }
            default:
                break
            }
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

struct VideoPlayerView: View {
    let player: AVPlayer
    var onDismiss: () -> Void

    @State private var countdown = 5
    @State private var timer: Timer? = nil

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VideoPlayer(player: player)
                .ignoresSafeArea()

            Button {
                timer?.invalidate()
                onDismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.5))
                        .frame(width: 40, height: 40)
                    if countdown > 0 {
                        Text("\(countdown)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .disabled(countdown > 0)
            .padding(20)
        }
        .onAppear {
            player.play()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
                if countdown > 0 {
                    countdown -= 1
                } else {
                    t.invalidate()
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
            player.pause()
        }
    }
}

struct HomeView: View {
    @State private var showVideo = false

    var body: some View {
        WebView(url: URL(string: "https://moget-fe.vercel.app/gacha")!, onShowVideo: { showVideo = true })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .fullScreenCover(isPresented: $showVideo) {
                if let url = Bundle.main.url(forResource: "0222", withExtension: "mov") {
                    VideoPlayerView(player: AVPlayer(url: url), onDismiss: { showVideo = false })
                }
            }
    }
}

#Preview {
    HomeView()
}
