import SwiftUI

struct MButton: View {
    enum Style {
        case normal
        case lightHover
        case white
        case gray100

        var backgroundColor: Color {
            switch self {
            case .normal:    return Color.DS.Purple.normal
            case .lightHover: return Color.DS.Purple.lightHover
            case .white:     return Color.DS.Gray.white
            case .gray100:   return Color.DS.Gray.g100
            }
        }

        var textColor: Color {
            switch self {
            case .normal:    return .white
            case .lightHover: return Color.DS.Purple.normal
            case .white:     return Color.DS.Purple.normal
            case .gray100:   return Color.DS.Gray.g500
            }
        }
    }

    let title: String
    let style: Style
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Pretendard-SemiBold", size: 16))
                .foregroundStyle(style.textColor)
                .padding(.vertical, 18)
                .padding(.horizontal, 24)
                .background(style.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        MButton(title: "버튼 텍스트", style: .normal, action: {})
        MButton(title: "버튼 텍스트", style: .lightHover, action: {})
        MButton(title: "버튼 텍스트", style: .white, action: {})
        MButton(title: "버튼 텍스트", style: .gray100, action: {})
    }
    .padding()
    .background(Color.DS.Gray.g50)
}
