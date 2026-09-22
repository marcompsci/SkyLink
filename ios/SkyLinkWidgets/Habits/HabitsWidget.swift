import SwiftUI
import WidgetKit

struct HabitsWidget: Widget {
    static let kind = "SkyLinkHabitsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: Self.kind, provider: HabitsProvider()) { entry in
            HabitsWidgetView(entry: entry)
                .containerBackground(SkyLinkPalette.mindflowBlue, for: .widget)
        }
        .configurationDisplayName("Habits")
        .description("Today's habits and streaks. Tick one without opening the app.")
        .supportedFamilies([
            .systemSmall,
            .systemLarge,
            .accessoryCircular,
            .accessoryRectangular
        ])
    }
}
