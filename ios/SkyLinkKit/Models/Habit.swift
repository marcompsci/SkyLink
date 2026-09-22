import Foundation

struct Habit: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var title: String
    var streak: Int
    var isDoneToday: Bool
    var scheduledTime: Date?

    /// True when this habit's detail lives in the private vault and may
    /// not be rendered while the vault is locked.
    var isPrivate: Bool

    init(
        id: UUID = UUID(),
        title: String,
        streak: Int = 0,
        isDoneToday: Bool = false,
        scheduledTime: Date? = nil,
        isPrivate: Bool = false
    ) {
        self.id = id
        self.title = title
        self.streak = streak
        self.isDoneToday = isDoneToday
        self.scheduledTime = scheduledTime
        self.isPrivate = isPrivate
    }
}
