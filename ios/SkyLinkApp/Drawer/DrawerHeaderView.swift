import SwiftUI

struct DrawerHeaderView: View {
    @Environment(GarageStore.self) private var garage

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(spacing: 10) {
                AutoSpriteView(state: .idle, size: 32)
                Text("SkyLink")
                    .font(.system(.body, weight: .bold))
                    .foregroundStyle(SkyLinkPalette.chrome)
            }

            HStack(spacing: 10) {
                Image(systemName: "car.side.fill")
                    .font(.system(.footnote))
                    .foregroundStyle(SkyLinkPalette.oilTeal)

                Text(garage.vehicle?.nickname ?? "No car yet")
                    .font(.system(.footnote, weight: .semibold))
                    .foregroundStyle(SkyLinkPalette.chrome)

                Spacer(minLength: 0)
            }
            .padding(12)
            .background(SkyLinkPalette.garageBlack, in: .rect(cornerRadius: 12))
        }
        .padding(.horizontal, 20)
        .padding(.top, 62)
        .padding(.bottom, 16)
        .overlay(alignment: .top) { HazardStripe() }
    }
}
