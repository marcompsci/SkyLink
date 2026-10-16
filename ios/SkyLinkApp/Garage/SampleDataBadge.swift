import SwiftUI

/// Sample data is never presented as live information. This badge is the
/// enforcement, and it is deliberately hard to miss.
struct SampleDataBadge: View {
    var body: some View {
        Text("SAMPLE")
            .font(.system(size: 9, weight: .bold, design: .monospaced))
            .kerning(1)
            .foregroundStyle(SkyLinkPalette.garageBlack)
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
            .background(SkyLinkPalette.torqueOrange, in: .capsule)
            .accessibilityLabel("Sample data, not from your car")
    }
}
