import SwiftUI
import CoreText

@main
struct MogetApp: App {
    @State private var showSplash = true

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
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                } else {
                    BirthdayView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: showSplash)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showSplash = false
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
