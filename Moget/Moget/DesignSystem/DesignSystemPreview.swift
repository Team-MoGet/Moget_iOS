import SwiftUI

struct DesignSystemPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                colorGroup("Purple", items: [
                    ("light",        Color.DS.Purple.light),
                    ("lightHover",   Color.DS.Purple.lightHover),
                    ("lightActive",  Color.DS.Purple.lightActive),
                    ("normal",       Color.DS.Purple.normal),
                    ("normalHover",  Color.DS.Purple.normalHover),
                    ("normalActive", Color.DS.Purple.normalActive),
                    ("dark",         Color.DS.Purple.dark),
                    ("darkHover",    Color.DS.Purple.darkHover),
                    ("darkActive",   Color.DS.Purple.darkActive),
                    ("darker",       Color.DS.Purple.darker),
                ])
                colorGroup("Gray", items: [
                    ("white", Color.DS.Gray.white),
                    ("g50",   Color.DS.Gray.g50),
                    ("g100",  Color.DS.Gray.g100),
                    ("g200",  Color.DS.Gray.g200),
                    ("g300",  Color.DS.Gray.g300),
                    ("g400",  Color.DS.Gray.g400),
                    ("g500",  Color.DS.Gray.g500),
                    ("g600",  Color.DS.Gray.g600),
                    ("g700",  Color.DS.Gray.g700),
                ])
            }
            .padding()
        }
    }

    func colorGroup(_ title: String, items: [(String, Color)]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            ForEach(items, id: \.0) { name, color in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color)
                        .frame(width: 44, height: 28)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.1)))
                    Text(name).font(.system(.caption, design: .monospaced))
                }
            }
        }
    }
}

#Preview {
    DesignSystemPreview()
}
