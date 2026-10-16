import SwiftUI

struct HealthStripView: View {
    @Environment(GarageStore.self) private var garage

    var body: some View {
        HStack(spacing: 9) {
            ForEach(tiles, id: \.title) { tile in
                HealthTileView(title: tile.title, severity: tile.severity)
            }
        }
    }

    private var tiles: [(title: String, severity: DiagnosticSeverity)] {
        let mileage = garage.currentMileage
        let oil = garage.reminders.first { $0.title.contains("Oil") }
        let tires = garage.reminders.first { $0.title.contains("Tire") }

        return [
            ("Oil", oil?.severity(currentMileage: mileage) ?? .safe),
            ("Tires", tires?.severity(currentMileage: mileage) ?? .safe),
            ("Brakes", .safe),
            ("Papers", .safe),
        ]
    }
}
