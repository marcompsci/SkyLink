import SwiftUI
import WidgetKit

struct VehicleWidgetView: View {
    @Environment(\.widgetFamily) private var family

    let entry: VehicleEntry

    var body: some View {
        switch family {
        case .accessoryRectangular:
            VehicleRectangularView(vehicle: entry.vehicle)
        default:
            VehicleMediumView(vehicle: entry.vehicle)
        }
    }
}
