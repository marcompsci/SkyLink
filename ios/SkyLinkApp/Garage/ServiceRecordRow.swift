import SwiftUI

struct ServiceRecordRow: View {
    let record: ServiceRecord

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: record.performer == .you ? "wrench.adjustable.fill" : "building.2.fill")
                .font(.system(.footnote))
                .foregroundStyle(record.performer == .you ? SkyLinkPalette.oilTeal : SkyLinkPalette.grease)
                .frame(width: 32, height: 32)
                .background(SkyLinkPalette.garageBlack, in: .rect(cornerRadius: 9))

            VStack(alignment: .leading, spacing: 2) {
                Text(record.title)
                    .font(.system(.footnote, weight: .semibold))
                    .foregroundStyle(SkyLinkPalette.chrome)

                Text(subtitle)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(SkyLinkPalette.grease)
            }

            Spacer(minLength: 4)

            if let cents = record.costCents {
                Text((Double(cents) / 100).formatted(.currency(code: "USD").precision(.fractionLength(0))))
                    .font(.system(.footnote, design: .monospaced, weight: .bold))
                    .foregroundStyle(SkyLinkPalette.chrome)
            }
        }
        .padding(12)
        .background(SkyLinkPalette.steel, in: .rect(cornerRadius: 13))
    }

    private var subtitle: String {
        var parts: [String] = [record.performer == .you ? "You did it" : (record.shopName ?? "Shop")]
        if let mileage = record.mileage { parts.append("\(mileage.formatted()) mi") }
        parts.append(record.performedAt.formatted(.dateTime.month().day()))
        return parts.joined(separator: " · ")
    }
}
