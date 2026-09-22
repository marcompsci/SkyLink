import SwiftUI
import WidgetKit

/// The interactive family. Each row's checkbox runs `ToggleHabitIntent`
/// in the background — no app launch, no approval step, because logging a
/// habit is on the low-risk list.
struct HabitsLargeView: View {
    let snapshot: DashboardSnapshot?

    var body: some View {
        if let snapshot {
            VStack(alignment: .leading, spacing: 10) {
                HabitsLargeHeaderView(updatedAt: snapshot.updatedAt)

                ForEach(snapshot.renderableHabits.prefix(5)) { habit in
                    HabitRowView(habit: habit)
                }

                if snapshot.hasHiddenPrivateHabits {
                    VaultLockedRowView()
                }

                Spacer(minLength: 0)

                if snapshot.budgetFreshness.requiresProminentBadge {
                    FreshnessStampView(freshness: snapshot.budgetFreshness)
                }
            }
        } else {
            WidgetEmptyView(message: "Open SkyLink to set up habits")
        }
    }
}

#Preview(as: .systemLarge) {
    HabitsWidget()
} timeline: {
    HabitsEntry(date: .now, snapshot: .placeholder)
}
