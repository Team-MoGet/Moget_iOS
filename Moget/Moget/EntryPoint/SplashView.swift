import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            Image("Frame14")
                .resizable()
                .frame(width: 100, height: 100)
        }
    }
}

#Preview {
    SplashView()
}
