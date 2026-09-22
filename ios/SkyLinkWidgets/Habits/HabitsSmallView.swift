import SwiftUI
import WidgetKit

struct HabitsSmallView: View {
    let snapshot: DashboardSnapshot?

    var body: some View {
        if let snapshot {
            VStack(alignment: .leading, spacing: 8) {
                Text("MindFlow")
                    .font(.system(size: 10, weight: .semibold))
                    .textCase(.uppercase)
                    .foregroundStyle(.white.opacity(0.7))

                Spacer(minLength: 0)

                HabitsRingView(
                    completed: snapshot.completedCount,
                    total: snapshot.totalCount
                )
                .frame(maxWidth: .infinity)

                Spacer(minLength: 0)

                Text("Habits today")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)

                if snapshot.budgetFreshness.requiresProminentBadge {
                    FreshnessStampView(freshness: snapshot.budgetFreshness)
                }
            }
        } else {
            WidgetEmptyView(message: "Open SkyLink to set up habits")
        }
    }
}

#Preview(as: .systemSmall) {
    HabitsWidget()
} timeline: {
    HabitsEntry(date: .now, snapshot: .placeholder)
    HabitsEntry(date: .now, snapshot: nil)
}
