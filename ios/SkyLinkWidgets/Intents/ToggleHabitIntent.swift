import AppIntents
import WidgetKit

/// Ticks a habit straight from the widget, without launching the app.
///
/// Low-risk by design: creating tasks, logging habits, and recording
/// expenses run inline. Calendar writes, deletions, messages, and anything
/// financial require the propose-approve loop and therefore open the app.
/// See docs/14-mindflow.md.
struct ToggleHabitIntent: AppIntent {
    static let title: LocalizedStringResource = "Toggle habit"
    static let description = IntentDescription("Marks a habit complete or undoes it for today.")

    /// The widget runs this in the background; no UI needs to appear.
    static let openAppWhenRun = false

    @Parameter(title: "Habit ID")
    var habitID: String

    init() {}

    init(habitID: UUID) {
        self.habitID = habitID.uuidString
    }

    func perform() async throws -> some IntentResult {
        guard let id = UUID(uuidString: habitID) else {
            throw ToggleHabitError.unknownHabit
        }

        guard SharedStore.toggleHabit(id: id) else {
            throw ToggleHabitError.unknownHabit
        }

        return .result()
    }
}
