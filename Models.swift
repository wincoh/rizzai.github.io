import Foundation

enum RizzStyle: String, CaseIterable, Identifiable {
    case smooth = "Smooth"
    case flirty = "Flirty"
    case funny = "Funny"
    case bold = "Bold"
    case romantic = "Romantic"
    case casual = "Casual"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .smooth: return "😎"
        case .flirty: return "😏"
        case .funny: return "😂"
        case .bold: return "🔥"
        case .romantic: return "❤️"
        case .casual: return "🙂"
        }
    }
}

struct RizzResult: Identifiable {
    let id = UUID()
    let reply: String
    let score: Int
}
