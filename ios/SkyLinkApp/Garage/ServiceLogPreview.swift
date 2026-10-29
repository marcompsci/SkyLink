import SwiftUI

struct ServiceLogPreview: View {
    @Environment(GarageStore.self) private var garage
    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack(alignment: .firstTextBaseline) {
                Text("Service log").skyLabel(SkyLinkPalette.grease)

                Spacer()

                Text(spentThisYear)
                    .font(SkyType.mono)
                    .foregroundStyle(SkyLinkPalette.oilTeal)
            }

            ForEach(garage.records.prefix(3)) { record in
                ServiceRecordRow(record: record)
            }

            Button("See all", action: openLog)
                .font(SkyType.callout)
                .tint(SkyLinkPalette.grease)
                .buttonStyle(.control)
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
