import SwiftUI
import WidgetKit

/// Routes to the right view for the family. Each family lives in its own
/// file so none of these bodies grows past a screenful.
struct HabitsWidgetView: View {
    @Environment(\.widgetFamily) private var family

    let entry: HabitsEntry

    var body: some View {
        switch family {
        case .systemSmall:
            HabitsSmallView(snapshot: entry.snapshot)
        case .systemLarge:
            HabitsLargeView(snapshot: entry.snapshot)
        case .accessoryCircular:
            HabitsCircularView(snapshot: entry.snapshot)
        case .accessoryRectangular:
            HabitsRectangularView(snapshot: entry.snapshot)
        default:
            HabitsSmallView(snapshot: entry.snapshot)
        }
    }
}
