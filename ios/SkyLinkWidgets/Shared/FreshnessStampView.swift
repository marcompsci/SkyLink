import SwiftUI

/// The "where did this number come from" badge. Required on every panel
/// that shows connected data, and unmissable on demo data.
struct FreshnessStampView: View {
    let freshness: DataFreshness

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(freshness.tint)
                .frame(width: 5, height: 5)

            Text(freshness.label)
                .font(.system(size: 9, weight: .semibold, design: .monospaced))
                .textCase(.uppercase)
                .foregroundStyle(freshness == .demo ? freshness.tint : .secondary)
        }
        .accessibilityElement(children: .combine)
    }
}
