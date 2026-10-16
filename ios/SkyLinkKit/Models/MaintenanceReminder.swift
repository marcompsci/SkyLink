import Foundation

/// A reminder that fires on **mileage or date, whichever lands first**.
///
/// Date-only reminders are the main failure of existing apps: a 5,000-mile oil
/// change is six weeks for a delivery driver and ten months for someone who
/// works from home. For the wedge audience in docs/01, mileage is the only
/// unit that means anything.
struct MaintenanceReminder: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var title: String
    var intervalMiles: Int?
    var intervalMonths: Int?
    var lastDoneMileage: Int?
    var lastDoneAt: Date?

    init(
        id: UUID = UUID(),
        title: String,
        intervalMiles: Int? = nil,
        intervalMonths: Int? = nil,
        lastDoneMileage: Int? = nil,
        lastDoneAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.intervalMiles = intervalMiles
        self.intervalMonths = intervalMonths
        self.lastDoneMileage = lastDoneMileage
        self.lastDoneAt = lastDoneAt
    }
}
