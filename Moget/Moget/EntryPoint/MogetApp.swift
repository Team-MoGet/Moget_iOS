import SwiftUI
import CoreText
import KakaoSDKCommon

@main
struct MogetApp: App {
    @State private var showSplash = true
    @State private var showHome = false

    init() {
        let fontNames = [
            "Pretendard-Thin", "Pretendard-ExtraLight", "Pretendard-Light",
            "Pretendard-Regular", "Pretendard-Medium", "Pretendard-SemiBold",
            "Pretendard-Bold", "Pretendard-ExtraBold", "Pretendard-Black"
        ]
        for name in fontNames {
            guard let url = Bundle.main.url(forResource: name, withExtension: "otf") else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
        KakaoSDK.initSDK(appKey: "565903385303eb5946fac8a52ba34778")
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                } else if showHome {
                    HomeView()
                        .ignoresSafeArea(.all)
                        .transition(.opacity)
                } else {
                    BirthdayView(onNext: { showHome = true })
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: showSplash)
            .animation(.easeInOut(duration: 0.4), value: showHome)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showSplash = false
                }
            }
            .preferredColorScheme(.light)

        }
    }
}
