import SwiftUI

struct ContentView: View {
    @StateObject private var service = RizzAIService()
    @State private var message = ""
    @State private var selectedStyle: RizzStyle = .flirty
    @State private var result: RizzResult?
    @State private var showHistory = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        header

                        messageCard

                        styleSection

                        generateButton

                        if let result {
                            resultCard(result)
                        }

                        Spacer(minLength: 30)
                    }
                    .padding(20)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showHistory) {
                HistoryView()
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("RizzAI")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Never get left on read again.")
                    .foregroundStyle(.white.opacity(0.55))
            }

            Spacer()

            Button {
                showHistory = true
            } label: {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(.white.opacity(0.08))
                    .clipShape(Circle())
            }
        }
    }

    private var messageCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("WHAT DID THEY SAY?")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.45))

            TextEditor(text: $message)
                .scrollContentBackground(.hidden)
                .foregroundStyle(.white)
                .frame(minHeight: 130)
                .padding(12)
                .background(Color.white.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.08))
                }

            HStack {
                Text("\(message.count)/500")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.35))

                Spacer()

                Button("Paste") {
                    message = UIPasteboard.general.string ?? ""
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.75))
            }
        }
    }

    private var styleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RIZZ STYLE")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.45))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(RizzStyle.allCases) { style in
                        Button {
                            selectedStyle = style
                        } label: {
                            HStack(spacing: 7) {
                                Text(style.emoji)
                                Text(style.rawValue)
                                    .font(.subheadline.weight(.semibold))
                            }
                            .foregroundStyle(selectedStyle == style ? .black : .white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 11)
                            .background(
                                selectedStyle == style
                                ? Color.white
                                : Color.white.opacity(0.07)
                            )
                            .clipShape(Capsule())
                        }
                    }
                }
            }
        }
    }

    private var generateButton: some View {
        Button {
            Task {
                result = await service.generateReply(to: message, style: selectedStyle)
            }
        } label: {
            HStack {
                if service.isGenerating {
                    ProgressView()
                        .tint(.black)
                } else {
                    Image(systemName: "sparkles")
                }

                Text(service.isGenerating ? "Cooking..." : "Generate Rizz")
                    .font(.headline.weight(.bold))
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || service.isGenerating)
        .opacity(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.45 : 1)
    }

    private func resultCard(_ result: RizzResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("YOUR RIZZ")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.45))

                Spacer()

                Text("\(result.score)/100")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
            }

            Text(result.reply)
                .font(.system(size: 21, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 10) {
                Button {
                    UIPasteboard.general.string = result.reply
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                }
                .buttonStyle(RizzSecondaryButtonStyle())

                Button {
                    Task {
                        self.result = await service.generateReply(to: message, style: selectedStyle)
                    }
                } label: {
                    Label("Try Again", systemImage: "arrow.clockwise")
                }
                .buttonStyle(RizzSecondaryButtonStyle())
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.white.opacity(0.10), .white.opacity(0.045)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(.white.opacity(0.09))
        }
    }
}

struct RizzSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(.white.opacity(configuration.isPressed ? 0.14 : 0.08))
            .clipShape(Capsule())
    }
}

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 16) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.8))

                    Text("Your Rizz History")
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    Text("Saved replies will appear here in the next version.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.horizontal, 40)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
