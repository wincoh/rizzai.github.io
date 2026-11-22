import Foundation

@MainActor
final class RizzAIService: ObservableObject {
    @Published var isGenerating = false

    func generateReply(to message: String, style: RizzStyle) async -> RizzResult {
        isGenerating = true
        defer { isGenerating = false }

        // Demo engine. Replace this with a call to your secure backend/API.
        try? await Task.sleep(for: .milliseconds(650))

        let clean = message.trimmingCharacters(in: .whitespacesAndNewlines)
        let reply: String

        switch style {
        case .smooth:
            reply = "You make it pretty easy to keep the conversation interesting."
        case .flirty:
            reply = "Careful… keep talking like that and I might actually start liking you 😏"
        case .funny:
            reply = "I had a clever response ready, but honestly you just made me forget it 😂"
        case .bold:
            reply = "I’m not here to play it safe. Let’s see where this goes 🔥"
        case .romantic:
            reply = "Something about talking to you makes the rest of the conversation feel a little less important."
        case .casual:
            reply = "Okay, I see you. What are you getting into tonight?"
        }

        let score = min(99, max(72, 78 + clean.count % 22))
        return RizzResult(reply: reply, score: score)
    }
}
