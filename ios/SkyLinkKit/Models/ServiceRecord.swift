import Foundation

/// One entry in the service log. DIY and shop work live in the same list —
/// the research is clear that a log which only covers one is the single most
/// common complaint about this category. See docs/15-pocket-garage.md.
struct ServiceRecord: Identifiable, Codable, Hashable, Sendable {
    enum Performer: String, Codable, Sendable {
        case you
        case shop
    }

    let id: UUID
    var title: String
    var performedAt: Date
    var mileage: Int?
    var costCents: Int?
    var performer: Performer
    var shopName: String?
    var notes: String?

    init(
        id: UUID = UUID(),
        title: String,
        performedAt: Date,
        mileage: Int? = nil,
        costCents: Int? = nil,
        performer: Performer = .you,
        shopName: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.title = title
        self.performedAt = performedAt
        self.mileage = mileage
        self.costCents = costCents
        self.performer = performer
        self.shopName = shopName
        self.notes = notes
    }
}
