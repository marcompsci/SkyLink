import SwiftUI

struct ServiceLogPreview: View {
    @Environment(GarageStore.self) private var garage
    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack(alignment: .firstTextBaseline) {
                Text("SERVICE LOG")
                    .font(.system(size: 11, weight: .bold))
                    .kerning(1.8)
                    .foregroundStyle(SkyLinkPalette.grease)

                Spacer()

                Text(spentThisYear)
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(SkyLinkPalette.oilTeal)
            }

            ForEach(garage.records.prefix(3)) { record in
                ServiceRecordRow(record: record)
            }

            Button("See all", action: openLog)
                .font(.system(size: 13, weight: .semibold))
                .tint(SkyLinkPalette.grease)
        }
    }

    private var spentThisYear: String {
        let dollars = Double(garage.spentThisYearCents) / 100
        return "\(dollars.formatted(.currency(code: "USD").precision(.fractionLength(0)))) this year"
    }

    private func openLog() {
        router.show(.serviceLog)
    }
}
