import Foundation

/// Everything the widgets are allowed to render, written by the app and
/// read by the widget extension through the shared App Group container.
///
/// The widget process never talks to the network and never holds a vault
/// key. If `isVaultLocked` is true it renders a placeholder instead of
/// private values — see docs/14-mindflow.md.
struct DashboardSnapshot: Codable, Hashable, Sendable {
    var habits: [Habit]
    var budgetRemaining: Decimal?
    var budgetTotal: Decimal?
    var budgetFreshness: DataFreshness
    var vehicle: VehicleStatus?
    var isVaultLocked: Bool
    var updatedAt: Date

    var completedCount: Int {
        habits.filter(\.isDoneToday).count
    }

    var totalCount: Int {
        habits.count
    }

    /// Habits safe to show while the vault is locked.
    var renderableHabits: [Habit] {
        isVaultLocked ? habits.filter { $0.isPrivate == false } : habits
    }

    var hasHiddenPrivateHabits: Bool {
        isVaultLocked && habits.contains(where: \.isPrivate)
    }
}
