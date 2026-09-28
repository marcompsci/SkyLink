import SwiftUI

struct CompanionView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var messages: [CompanionMessage] = []
    @State private var isListening = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skyBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    infoCard

                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                if messages.isEmpty {
                                    companionEmpty
                                } else {
                                    ForEach(messages) { msg in
                                        CompanionBubble(message: msg).id(msg.id)
                                    }
                                }
                            }
                            .padding(16)
                        }
                        .onChange(of: messages.count) { _, _ in
                            if let last = messages.last {
                                withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                            }
                        }
                    }

                    listenBar
                }
            }
            .navigationTitle("Companion")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
        .onAppear {
            if messages.isEmpty {
                addCompanionMessage("Hi! I'm your SkyLink Companion. I can help you navigate the app, understand your car, or just answer questions. What do you need?")
            }
        }
    }

    private var infoCard: some View {
        SkyCard {
            HStack(spacing: 12) {
                Image(systemName: "accessibility.fill")
                    .font(.title3)
                    .foregroundStyle(Color.skyBlue)
                    .frame(width: 36, height: 36)
                    .background(Color.skyBlue.opacity(0.15))
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text("Screen-Aware Assistant")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(Color.textPrimary)
                    Text("Ask me anything about what you see or need help with.")
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .padding(14)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var companionEmpty: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 40)
            VStack(spacing: 12) {
                SkySectionHeader(title: "Try saying")
            }
            ForEach(companionSuggestions, id: \.self) { suggestion in
                Button {
                    send(suggestion)
                } label: {
                    Text(suggestion)
                        .font(.callout)
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(Color.skyCard)
                        .foregroundStyle(Color.textSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }

    private let companionSuggestions = [
        "How do I read a fault code?",
        "How do I connect my OBD adapter?",
        "What does the SOS button do?",
        "How do I add my car?"
    ]

    private var listenBar: some View {
        HStack(spacing: 14) {
            Button {
                toggleListen()
            } label: {
                VoicePulseView(isActive: isListening)
                    .frame(width: 56, height: 56)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(isListening ? "Listening…" : "Tap to ask")
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(isListening ? Color.skyBlue : Color.textPrimary)
                if isListening && !env.voice.transcript.isEmpty {
                    Text(env.voice.transcript)
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(1)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.skyCard)
    }

    private func toggleListen() {
        if isListening {
            env.voice.stopListening()
            isListening = false
            let text = env.voice.transcript
            if !text.isEmpty { send(text) }
        } else {
            isListening = true
            env.voice.startListening { text in
                isListening = false
                guard !text.isEmpty else { return }
                send(text)
            }
        }
    }

    private func send(_ text: String) {
        messages.append(CompanionMessage(role: .user, text: text))
        Task {
            let context = """
            The user is using the SkyLink app. SkyLink has four tabs:
            - Sky (voice AI car assistant) 
            - Diagnose (OBD-II fault codes, live engine data, part finder)
            - SOS (roadside emergency)
            - MindFlow (voice journal)
            - Companion (you — screen-aware accessibility assistant)
            Answer concisely and helpfully.
            """
            let reply = await env.ai.ask(context + "\n\nUser question: " + text)
            await MainActor.run {
                addCompanionMessage(reply)
                env.voice.speak(reply)
            }
        }
    }

    private func addCompanionMessage(_ text: String) {
        messages.append(CompanionMessage(role: .companion, text: text))
    }
}

// MARK: - Types

struct CompanionMessage: Identifiable {
    enum Role { case user, companion }
    let id = UUID()
    let role: Role
    let text: String
}

struct CompanionBubble: View {
    let message: CompanionMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.role == .companion {
                Image(systemName: "accessibility.fill")
                    .font(.caption)
                    .foregroundStyle(Color.skyBlue)
                    .frame(width: 28, height: 28)
                    .background(Color.skyBlue.opacity(0.15))
                    .clipShape(Circle())
            }

            Text(message.text)
                .font(.callout)
                .padding(12)
                .background(message.role == .user ? Color.skyBlue : Color.skyCard)
                .foregroundStyle(Color.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .frame(maxWidth: 280,
                       alignment: message.role == .user ? .trailing : .leading)

            if message.role == .user { Spacer() }
        }
    }
}
