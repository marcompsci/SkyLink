import SwiftUI
import SwiftData

struct CarAssistantView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Vehicle.dateAdded) private var vehicles: [Vehicle]

    @State private var inputText = ""
    @State private var messages: [ChatMessage] = []
    @State private var showingAddVehicle = false
    @State private var showingRepairGuide: TriageIssue?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.skyBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Vehicle selector
                    if !vehicles.isEmpty {
                        vehicleChips
                    }

                    // Chat
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                if messages.isEmpty {
                                    emptyState
                                } else {
                                    ForEach(messages) { msg in
                                        ChatBubble(message: msg)
                                            .id(msg.id)
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

                    Spacer(minLength: 0)
                }

                // Input bar
                voiceInputBar
                    .background(Color.skyBackground)
            }
            .navigationTitle("Sky")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showingAddVehicle = true
                    } label: {
                        Image(systemName: "car.badge.plus")
                            .foregroundStyle(Color.skyBlue)
                    }
                }
            }
            .sheet(isPresented: $showingAddVehicle) {
                AddVehicleSheet()
            }
            .sheet(item: $showingRepairGuide) { issue in
                RepairGuideView(issue: issue)
            }
        }
    }

    // MARK: - Subviews

    private var vehicleChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(vehicles) { v in
                    Text(v.displayName)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Color.skyCard)
                        .foregroundStyle(Color.textSecondary)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 32) {
            Spacer(minLength: 60)
            Image(systemName: "waveform.and.car")
                .font(.system(size: 64))
                .foregroundStyle(Color.skyBlue)
            Text("Ask me anything about your car")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.textPrimary)
            VStack(spacing: 12) {
                ForEach(suggestions, id: \.self) { s in
                    Button {
                        send(s)
                    } label: {
                        Text(s)
                            .font(.callout)
                            .padding(.horizontal, 16).padding(.vertical, 10)
                            .background(Color.skyCard)
                            .foregroundStyle(Color.textSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }

    private let suggestions = [
        "What does the check engine light mean?",
        "How do I know if my brakes need replacing?",
        "My car makes a grinding noise when I turn.",
        "When should I change my oil?"
    ]

    private var voiceInputBar: some View {
        HStack(spacing: 12) {
            TextField("Ask about your car…", text: $inputText)
                .padding(12)
                .background(Color.skyCard)
                .foregroundStyle(Color.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .tint(Color.skyBlue)
                .submitLabel(.send)
                .onSubmit {
                    if !inputText.isEmpty {
                        send(inputText)
                        inputText = ""
                    }
                }

            Button {
                if env.voice.isListening {
                    env.voice.stopListening()
                } else {
                    env.voice.startListening { text in
                        guard !text.isEmpty else { return }
                        send(text)
                    }
                }
            } label: {
                VoicePulseView(isActive: env.voice.isListening)
                    .frame(width: 52, height: 52)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Send

    private func send(_ text: String) {
        let userMsg = ChatMessage(role: .user, text: text)
        messages.append(userMsg)
        inputText = ""

        Task {
            let reply = await env.ai.ask(text)
            await MainActor.run {
                let aiMsg = ChatMessage(role: .assistant, text: reply)
                messages.append(aiMsg)
                env.voice.speak(reply)
                // If response seems to be about a repair guide, offer one
                checkForGuideOffer(text: text, reply: reply)
            }
        }
    }

    private func checkForGuideOffer(text: String, reply: String) {
        let combined = (text + reply).lowercased()
        if combined.contains("flat tire") || combined.contains("change a tire") {
            let offer = ChatMessage(role: .assistant, text: "Want me to walk you through it step by step?", action: .showGuide(.flatTire))
            messages.append(offer)
        } else if combined.contains("jump start") || combined.contains("dead battery") {
            let offer = ChatMessage(role: .assistant, text: "Want me to walk you through a jump start?", action: .showGuide(.wontStart))
            messages.append(offer)
        }
    }
}

// MARK: - Chat Types

struct ChatMessage: Identifiable {
    enum Role { case user, assistant }
    enum Action { case showGuide(TriageIssue) }

    let id = UUID()
    let role: Role
    let text: String
    var action: Action?
    let date = Date()
}

struct ChatBubble: View {
    @Environment(AppEnvironment.self) private var env
    let message: ChatMessage
    @State private var showingGuide: TriageIssue?

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.role == .assistant {
                Image(systemName: "waveform.and.car")
                    .font(.caption)
                    .foregroundStyle(Color.skyBlue)
                    .frame(width: 28, height: 28)
                    .background(Color.skyCard)
                    .clipShape(Circle())
            }

            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 8) {
                Text(message.text)
                    .font(.callout)
                    .padding(12)
                    .background(message.role == .user ? Color.skyBlue : Color.skyCard)
                    .foregroundStyle(Color.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 14,
                                                style: .continuous))
                    .frame(maxWidth: 280,
                           alignment: message.role == .user ? .trailing : .leading)

                if let action = message.action {
                    switch action {
                    case .showGuide(let issue):
                        Button("Show me the steps →") {
                            showingGuide = issue
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.skyBlue)
                    }
                }
            }

            if message.role == .user { Spacer() }
        }
        .sheet(item: $showingGuide) { issue in
            RepairGuideView(issue: issue)
        }
    }
}

// MARK: - Add Vehicle Sheet

struct AddVehicleSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var make = ""
    @State private var model = ""
    @State private var year = ""
    @State private var vin = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skyBackground.ignoresSafeArea()
                Form {
                    Section("Vehicle Info") {
                        TextField("Make (e.g. Toyota)", text: $make)
                        TextField("Model (e.g. Camry)", text: $model)
                        TextField("Year (e.g. 2019)", text: $year)
                            #if os(iOS)
                            .keyboardType(.numberPad)
                            #endif
                        TextField("VIN (optional)", text: $vin)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Add Vehicle")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let y = Int(year) ?? 2020
                        let v = Vehicle(make: make, model: model, year: y, vin: vin)
                        modelContext.insert(v)
                        try? modelContext.save()
                        dismiss()
                    }
                    .disabled(make.isEmpty || model.isEmpty)
                }
            }
        }
    }
}
