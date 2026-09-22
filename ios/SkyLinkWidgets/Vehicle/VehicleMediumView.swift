import SwiftUI
import WidgetKit

struct VehicleMediumView: View {
    let vehicle: VehicleStatus?

    var body: some View {
        if let vehicle {
            HStack(spacing: 14) {
                VehicleSummaryView(vehicle: vehicle)
                VehicleSOSButtonView()
            }
        } else {
            WidgetEmptyView(message: "Add your car in SkyLink")
        }
    }
}

#Preview(as: .systemMedium) {
    VehicleWidget()
} timeline: {
    VehicleEntry(date: .now, vehicle: DashboardSnapshot.placeholder.vehicle)
    VehicleEntry(date: .now, vehicle: nil)
}
