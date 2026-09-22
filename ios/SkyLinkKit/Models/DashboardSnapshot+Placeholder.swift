import Foundation

extension DashboardSnapshot {
    /// Used for the widget gallery and SwiftUI previews only.
    ///
    /// Marked `.demo` so it can never be mistaken for real data: the views
    /// read that flag and badge themselves accordingly.
    static var placeholder: DashboardSnapshot {
        DashboardSnapshot(
            habits: [
                Habit(title: "Morning walk", streak: 12, isDoneToday: true),
                Habit(title: "Film one clip", streak: 4, isDoneToday: true),
                Habit(title: "Gym session", streak: 6),
                Habit(title: "Read 20 pages", streak: 2)
            ],
            budgetRemaining: 288,
            budgetTotal: 600,
            budgetFreshness: .demo,
            vehicle: VehicleStatus(
                nickname: "2016 Civic",
                mileage: 84_210,
                activeCode: "P0301",
                severity: .limited,
                milesToNextService: 290,
                freshness: .demo,
                updatedAt: .now
            ),
            isVaultLocked: false,
            updatedAt: .now
        )
    }
}
