import SwiftUI
import WidgetKit

struct VehicleRectangularView: View {
    let vehicle: VehicleStatus?

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(vehicle?.nickname ?? "SkyLink")
                .font(.headline)
                .widgetAccentable()

            if let severity = vehicle?.severity {
                Label(severity.label, systemImage: severity.symbolName)
                    .font(.caption)
            } else if let miles = vehicle?.milesToNextService {
                Text("Service in ^[\(miles) mile](inflect: true)")
                    .font(.caption)
            } else {
                Text("No alerts")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
