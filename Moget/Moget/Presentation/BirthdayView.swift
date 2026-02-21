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
    }
}

#Preview {
    BirthdayView()
}
