import SwiftUI

struct BirthdayView: View {
    @State private var birthdayText = ""

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Image("Frame14")
                        .resizable()
                        .frame(width: 64, height: 64)

                    Text("생일을 입력해주세요")
                        .font(.custom("Pretendard-Bold", size: 24))
                        .foregroundColor(.black)
                }

                ZStack(alignment: .leading) {
                    if birthdayText.isEmpty {
                        Text("YYYY / MM / DD")
                            .font(.custom("Pretendard-Medium", size: 15))
                            .foregroundColor(Color.DS.Gray.g300)
                            .padding(.horizontal, 16)
                    }
                    TextField("", text: $birthdayText)
                        .font(.custom("Pretendard-Medium", size: 15))
                        .foregroundColor(Color.DS.Gray.g700)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.DS.Gray.g200, lineWidth: 1)
                )
                .padding(.top, 24)
                .padding(.trailing, 28)
            }
            .padding(.top, 120)
            .padding(.leading, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .safeAreaInset(edge: .bottom) {
            Button(action: {}) {
                Text("다음")
                    .font(.custom("Pretendard-SemiBold", size: birthdayText.isEmpty ? 16 : 16))
                    .foregroundColor(birthdayText.isEmpty ? Color.DS.Gray.g400 : .white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(birthdayText.isEmpty ? Color.DS.Gray.g100 : Color.DS.Purple.normal)
                    .cornerRadius(12)
            }
            .disabled(birthdayText.isEmpty)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    BirthdayView()
}
