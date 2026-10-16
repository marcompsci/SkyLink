import SwiftUI

struct VehicleCardView: View {
    @Environment(GarageStore.self) private var garage

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                Image(systemName: "car.side.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(SkyLinkPalette.grease)
                    .frame(width: 58, height: 58)
                    .background(SkyLinkPalette.garageBlack, in: .rect(cornerRadius: 15))

                VStack(alignment: .leading, spacing: 3) {
                    Text(garage.vehicle?.nickname ?? "Add your car")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(SkyLinkPalette.chrome)

                    Text("\(garage.currentMileage.formatted()) mi")
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundStyle(SkyLinkPalette.grease)
                }

                Spacer()

                if let freshness = garage.vehicle?.freshness, freshness.requiresProminentBadge {
                    SampleDataBadge()
                }
            }

            if let reminder = garage.mostUrgentReminder {
                ReminderRowView(reminder: reminder, mileage: garage.currentMileage)
            }
        }
        .padding(17)
        .background(SkyLinkPalette.steel, in: .rect(cornerRadius: 20))
    }
}
