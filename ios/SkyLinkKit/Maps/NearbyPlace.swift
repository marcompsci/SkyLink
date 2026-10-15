import Foundation
import CoreLocation

struct NearbyPlace: Identifiable, Hashable, Sendable {
    let id: UUID
    var name: String
    var coordinate: CLLocationCoordinate2D
    var distanceMeters: CLLocationDistance
    var phoneNumber: String?
    var kind: NearbyPlaceKind

    /// Set only when a real price is known for the part in question, with its
    /// provenance. Never a guess — see docs/13-parts-finder.md.
    var quotedPriceCents: Int?
    var priceSource: String?
    var priceCheckedAt: Date?

    var distanceMiles: Double {
        distanceMeters / 1609.34
    }

    static func == (lhs: NearbyPlace, rhs: NearbyPlace) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
