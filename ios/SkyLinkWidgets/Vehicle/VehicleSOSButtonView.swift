import SwiftUI

/// Deep-links straight into roadside triage.
///
/// A link, not a `Button(intent:)`: SOS must open the app, because the
/// safety script and the location capture belong in the full flow, not in
/// a widget. Free on every tier — there is no entitlement check anywhere
/// in this path. See docs/adr/0002-sos-is-never-metered.md.
struct VehicleSOSButtonView: View {
    var body: some View {
        Link(destination: URL(string: "skylink://sos")!) {
            VStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 22, weight: .semibold))

                Text("SOS")
                    .font(.system(size: 12, weight: .heavy))
            }
            .foregroundStyle(.white)
            .frame(width: 74)
            .frame(maxHeight: .infinity)
            .background(SkyLinkPalette.stopRed, in: .rect(cornerRadius: 18))
        }
        .accessibilityLabel("Get roadside help")
    }
}
