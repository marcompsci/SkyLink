import SwiftUI
import WidgetKit

struct VehicleWidget: Widget {
    static let kind = "SkyLinkVehicleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: Self.kind, provider: VehicleProvider()) { entry in
            VehicleWidgetView(entry: entry)
                .containerBackground(SkyLinkPalette.midnight, for: .widget)
        }
        .configurationDisplayName("Your car")
        .description("Service due, active fault codes, and one tap to roadside help.")
        .supportedFamilies([.systemMedium, .accessoryRectangular])
    }
}
