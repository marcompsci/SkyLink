import SwiftUI
import SwiftData

struct MindFlowView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MindFlowEntry.date, order: .reverse) private var entries: [MindFlowEntry]

    @State private var isRecording = false
    @State private var recordingStart: Date?
    @State private var selectedMood: MindFlowMood = .neutral
    @State private var showMoodPicker = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skyBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Recording card
                    recordingCard
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)

                    if entries.isEmpty {
                        emptyState
                    } else {
                        List {
                            ForEach(entries) { entry in
                                MindFlowEntryRow(entry: entry)
                                    .listRowBackground(Color.skyCard)
                            }
                            .onDelete(perform: deleteEntries)
                        }
                        #if os(iOS)
                        .listStyle(.insetGrouped)
                        #else
                        .listStyle(.plain)
                        #endif
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("MindFlow")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }

    // MARK: - Recording Card

    private var recordingCard: some View {
        SkyCard(elevated: true) {
            VStack(spacing: 16) {
                HStack {
                    Text(isRecording ? "Recording…" : "New Entry")
                        .font(.headline)
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    if !isRecording {
                        moodButton
                    }
                }

                if isRecording {
                    VStack(spacing: 8) {
                        VoicePulseView(isActive: true)
                        if !env.voice.transcript.isEmpty {
                            Text(env.voice.transcript)
                                .font(.callout)
                                .foregroundStyle(Color.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                        } else {
                            Text("Listening… speak your thoughts")
                                .font(.callout)
                                .foregroundStyle(Color.textTertiary)
                        }
                    }
                }

                Button {
                    toggleRecording()
                } label: {
                    Text(isRecording ? "Done — Save Entry" : "Start Speaking")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(isRecording ? Color.safeGreen : Color.skyBlue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(16)
        }
    }

    private var moodButton: some View {
        Menu {
            ForEach(MindFlowMood.allCases, id: \.self) { mood in
                Button {
                    selectedMood = mood
                } label: {
                    Label(mood.rawValue.capitalized, systemImage: mood.symbol)
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: selectedMood.symbol)
                Text(selectedMood.rawValue.capitalized)
                    .font(.caption.weight(.semibold))
            }
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(Color.skyBackground)
            .foregroundStyle(Color.textSecondary)
            .clipShape(Capsule())
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "brain.head.profile")
                .font(.system(size: 56))
                .foregroundStyle(Color.skyBlue)
            Text("Track your thoughts by voice")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.textPrimary)
            Text("Tap \u{201C}Start Speaking\u{201D} and talk freely.\nSkyLink transcribes and saves your entry.")
                .font(.callout)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }

    // MARK: - Actions

    private func toggleRecording() {
        if isRecording {
            env.voice.stopListening()
            let transcript = env.voice.transcript
            isRecording = false
            guard !transcript.isEmpty else { return }
            let duration = recordingStart.map { Date().timeIntervalSince($0) } ?? 0
            let entry = MindFlowEntry(
                transcription: transcript,
                mood: selectedMood,
                duration: duration
            )
            modelContext.insert(entry)
            try? modelContext.save()
        } else {
            recordingStart = Date()
            isRecording = true
            env.voice.startListening { _ in }
        }
    }

    private func deleteEntries(at offsets: IndexSet) {
        for i in offsets { modelContext.delete(entries[i]) }
        try? modelContext.save()
    }
}

// MARK: - Entry Row

private struct MindFlowEntryRow: View {
    let entry: MindFlowEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: entry.mood.symbol)
                    .foregroundStyle(entry.mood.tintColor)
                    .font(.callout)
                Text(entry.date, style: .relative)
                    .font(.caption)
                    .foregroundStyle(Color.textTertiary)
                Spacer()
                if entry.durationSeconds > 0 {
                    Text(formatDuration(entry.durationSeconds))
                        .font(.caption)
                        .foregroundStyle(Color.textTertiary)
                }
            }
            Text(entry.transcription)
                .font(.callout)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(3)
            if !entry.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(entry.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 10, weight: .semibold))
                                .padding(.horizontal, 8).padding(.vertical, 3)
                                .background(Color.skyBlue.opacity(0.15))
                                .foregroundStyle(Color.skyBlue)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func formatDuration(_ seconds: Double) -> String {
        let s = Int(seconds)
        return s >= 60 ? "\(s/60)m \(s%60)s" : "\(s)s"
    }
}
