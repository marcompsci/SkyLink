import SwiftUI
import WidgetKit

/// Lock Screen, circular. One glanceable number and nothing sensitive —
/// no balances, no transactions, no health values.
struct HabitsCircularView: View {
    let snapshot: DashboardSnapshot?

    var body: some View {
        Gauge(value: fraction) {
            Image(systemName: "checkmark")
        } currentValueLabel: {
            Text("\(snapshot?.completedCount ?? 0)")
        }
        .gaugeStyle(.accessoryCircular)
        .widgetAccentable()
        .accessibilityLabel("Habits complete today")
    }

    private var fraction: Double {
        guard let snapshot, snapshot.totalCount > 0 else { return 0 }
        return Double(snapshot.completedCount) / Double(snapshot.totalCount)
    }
}
