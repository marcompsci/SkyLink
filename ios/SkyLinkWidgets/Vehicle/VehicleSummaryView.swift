import SwiftUI

struct VehicleSummaryView: View {
    let vehicle: VehicleStatus

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("SkyLink Auto")
                .font(.system(size: 10, weight: .bold))
                .textCase(.uppercase)
                .foregroundStyle(SkyLinkPalette.signalTeal)

            Text(vehicle.nickname)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)

            if let severity = vehicle.severity, let code = vehicle.activeCode {
                Label {
                    Text("\(code) · \(severity.label)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(severity.tint)
                } icon: {
                    Image(systemName: severity.symbolName)
                        .foregroundStyle(severity.tint)
                }
                .labelStyle(.titleAndIcon)
            }

            if let miles = vehicle.milesToNextService {
                Text("Oil change due in ^[\(miles) mile](inflect: true)")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.7))
            }

            Spacer(minLength: 0)

            FreshnessStampView(freshness: vehicle.freshness)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
