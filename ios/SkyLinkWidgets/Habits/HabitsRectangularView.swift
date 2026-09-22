import SwiftUI
import WidgetKit

/// Lock Screen, rectangular. Shows the next thing due, never an amount.
struct HabitsRectangularView: View {
    let snapshot: DashboardSnapshot?

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("MindFlow")
                .font(.headline)
                .widgetAccentable()

            if let next = nextHabit {
                Text(next.title)
                    .font(.body)
                    .lineLimit(1)

                if let time = next.scheduledTime {
                    Text(time, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("All done today")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var nextHabit: Habit? {
        snapshot?.renderableHabits.first { $0.isDoneToday == false }
    }
}
