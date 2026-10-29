import CoreLocation
import SwiftUI

/// Location is captured and shown so the user can read it to a tow operator.
/// Works offline; sends when signal returns.
struct SOSLocationCardView: View {
    @State private var location = LocationAuthorization()

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 9) {
                Image(systemName: "location.fill")
                    .font(.system(.footnote))
                    .foregroundStyle(SkyLinkPalette.oilTeal)

                Text("LOCATION")
                    .font(.system(.caption, weight: .bold))
                    .kerning(1.2)
                    .foregroundStyle(SkyLinkPalette.oilTeal)

                Spacer()

                Text(location.canUseLiveLocation ? "Saved offline" : "Not shared")
                    .font(.system(.caption))
                    .foregroundStyle(SOSPalette.dim)
            }

            if location.canUseLiveLocation, let fix = location.lastFix {
                Text(coordinateText(for: fix.coordinate))
                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                    .foregroundStyle(SOSPalette.text)
            } else {
                Button("Share my location", systemImage: "location", action: location.requestWhenInUse)
                    .font(.system(.footnote, weight: .semibold))
                    .tint(SkyLinkPalette.oilTeal)
            }

            Text("Auto never tracks you in the background. This is asked for now because you need it now.")
                .font(.system(.caption))
                .foregroundStyle(SOSPalette.dim)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(SOSPalette.card, in: .rect(cornerRadius: 16))
        .overlay { RoundedRectangle(cornerRadius: 16).stroke(SOSPalette.border, lineWidth: 1) }
        .task { location.requestOneFix() }
    }

    private func coordinateText(for coordinate: CLLocationCoordinate2D) -> String {
        String(format: "%.5f, %.5f", coordinate.latitude, coordinate.longitude)
    }
}
