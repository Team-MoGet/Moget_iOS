import SwiftUI

struct BirthdayView: View {
    var onNext: () -> Void = {}
    @State private var birthdayText = ""
    @State private var isLoading = false
    @State private var showError = false
    @FocusState private var isFocused: Bool

    private var formattedBirthday: String {
        let y = birthdayText.prefix(4)
        let m = birthdayText.dropFirst(4).prefix(2)
        let d = birthdayText.dropFirst(6).prefix(2)
        return "\(y)-\(m)-\(d)"
    }

    private func registerBirthday() {
        guard let url = URL(string: "https://mainly-massive-cricket.ngrok-free.app/birthday") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["birthday": formattedBirthday])

        isLoading = true
        URLSession.shared.dataTask(with: request) { _, response, _ in
            DispatchQueue.main.async {
                isLoading = false
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    onNext()
                } else {
                    showError = true
                }
            }
        }.resume()
    }

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
                        .focused($isFocused)
                        .keyboardType(.numberPad)
                        .onChange(of: birthdayText) { _, newValue in
                            birthdayText = newValue.filter { $0.isNumber }
                        }
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
        .onTapGesture { isFocused = false }
        .safeAreaInset(edge: .bottom) {
            Button(action: { registerBirthday() }) {
                Group {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("다음")
                            .font(.custom("Pretendard-SemiBold", size: 16))
                            .foregroundColor(birthdayText.count >= 8 ? .white : Color.DS.Gray.g400)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(birthdayText.count >= 8 ? Color.DS.Purple.normal : Color.DS.Gray.g100)
                .cornerRadius(12)
            }
            .disabled(birthdayText.count < 8 || isLoading)
            .alert("날짜 형식을 확인해주세요", isPresented: $showError) {
                Button("확인", role: .cancel) {}
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    BirthdayView()
}
