import SwiftUI

struct HealthTileView: View {
    let title: String
    let severity: DiagnosticSeverity

    var body: some View {
        VStack(spacing: 7) {
            Circle()
                .fill(severity.tint)
                .frame(width: 9, height: 9)

            Text(title)
                .font(.system(.caption, weight: .semibold))
                .foregroundStyle(SkyLinkPalette.chrome)

            Text(severity.label)
                .font(.system(.caption2))
                .foregroundStyle(SkyLinkPalette.grease)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(SkyLinkPalette.steel, in: .rect(cornerRadius: 14))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(severity.label)")
    }
}
