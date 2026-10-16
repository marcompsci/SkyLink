import Observation
import SwiftUI

/// The app's own state: the active vehicle, its service log, and its
/// reminders. Publishes a trimmed snapshot to the App Group so the widgets
/// can read it.
///
/// Seeded with sample data **marked `.demo`** on first run so the app is not
/// an empty shell before onboarding exists. Every view reads that flag and
/// badges itself — sample data is never dressed as live.
@MainActor
@Observable
final class GarageStore {
    var vehicle: VehicleStatus?
    var records: [ServiceRecord] = []
    var reminders: [MaintenanceReminder] = []

    init() {
        loadSeed()
        publishToWidgets()
    }

    var currentMileage: Int {
        vehicle?.mileage ?? 0
    }

    /// The reminder closest to due. Drives the "next up" line on the Garage.
    var mostUrgentReminder: MaintenanceReminder? {
        reminders.min { lhs, rhs in
            let l = lhs.milesRemaining(currentMileage: currentMileage) ?? .max
            let r = rhs.milesRemaining(currentMileage: currentMileage) ?? .max
            return l < r
        }
    }

    var spentThisYearCents: Int {
        let year = Calendar.current.component(.year, from: .now)
        return records
            .filter { Calendar.current.component(.year, from: $0.performedAt) == year }
            .compactMap(\.costCents)
            .reduce(0, +)
    }

    func log(_ record: ServiceRecord) {
        records.insert(record, at: 0)
        publishToWidgets()
    }

    func updateMileage(_ miles: Int) {
        vehicle?.mileage = miles
        vehicle?.updatedAt = .now
        publishToWidgets()
    }

    /// The widget process gets only what it is allowed to render.
    func publishToWidgets() {
        SharedStore.save(VehicleSnapshot(vehicle: vehicle, updatedAt: .now))
    }

    private func loadSeed() {
        vehicle = VehicleStatus(
            nickname: "2016 Civic",
            mileage: 86_410,
            activeCode: nil,
            severity: nil,
            milesToNextService: 290,
            freshness: .demo,
            updatedAt: .now
        )

        reminders = [
            MaintenanceReminder(
                title: "Oil & filter change",
                intervalMiles: 5_000,
                intervalMonths: 6,
                lastDoneMileage: 81_400,
                lastDoneAt: Calendar.current.date(byAdding: .month, value: -4, to: .now)
            ),
            MaintenanceReminder(
                title: "Tire rotation",
                intervalMiles: 6_000,
                intervalMonths: 6,
                lastDoneMileage: 81_400,
                lastDoneAt: Calendar.current.date(byAdding: .month, value: -4, to: .now)
            ),
        ]

        records = [
            ServiceRecord(
                title: "Oil & filter change",
                performedAt: Calendar.current.date(byAdding: .month, value: -4, to: .now) ?? .now,
                mileage: 81_400,
                costCents: 3_100,
                performer: .you
            ),
            ServiceRecord(
                title: "Two front tires",
                performedAt: Calendar.current.date(byAdding: .month, value: -7, to: .now) ?? .now,
                mileage: 78_100,
                costCents: 28_700,
                performer: .shop,
                shopName: "Pep Boys"
            ),
        ]
    }
}
