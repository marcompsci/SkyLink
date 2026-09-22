import AppIntents

/// The Siri and Shortcuts entry point: "Hey Siri, log my walk in SkyLink."
///
/// Siri is an entry point, not a bypass. This intent only performs actions
/// that are low-risk by the rules in docs/14-mindflow.md; anything on the
/// explicit-approval list opens the app instead.
struct LogHabitIntent: AppIntent {
    static let title: LocalizedStringResource = "Log a habit"
    static let description = IntentDescription("Marks one of your MindFlow habits complete for today.")
    static let openAppWhenRun = false

    @Parameter(title: "Habit")
    var habitName: String

    init() {}

    init(habitName: String) {
        self.habitName = habitName
    }

    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let snapshot = SharedStore.loadSnapshot() else {
            return .result(dialog: "There's nothing in MindFlow yet.")
        }

        let needle = habitName.lowercased()
        let match = snapshot.habits.first { $0.title.lowercased().contains(needle) }

        guard let match else {
            return .result(dialog: "I couldn't find a habit called \(habitName).")
        }

        guard match.isDoneToday == false else {
            return .result(dialog: "\(match.title) is already done today.")
        }

        SharedStore.toggleHabit(id: match.id)
        return .result(dialog: "Logged \(match.title). That's \(match.streak + 1) days.")
    }
}
