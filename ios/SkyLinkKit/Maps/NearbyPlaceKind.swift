import Foundation

/// What Auto searches for when someone needs to go somewhere.
///
/// Hardware stores are in the list on purpose: tools, bolts and consumables
/// are routinely cheaper there than at a parts counter, and a first-timer
/// usually needs the socket more than the brand choice on the filter.
///
/// Search is by natural-language term rather than `MKPointOfInterestCategory`
/// on purpose — the automotive-repair category is a recent addition and gating
/// on its availability buys nothing here. The term works on every supported OS.
enum NearbyPlaceKind: String, CaseIterable, Sendable {
    case repairShop
    case partsStore
    case hardwareStore
    case gasStation
    case carWash

    var searchTerm: String {
        switch self {
        case .repairShop: "auto repair"
        case .partsStore: "auto parts store"
        case .hardwareStore: "hardware store"
        case .gasStation: "gas station"
        case .carWash: "car wash"
        }
    }

    var label: String {
        switch self {
        case .repairShop: "Repair shops"
        case .partsStore: "Parts stores"
        case .hardwareStore: "Hardware stores"
        case .gasStation: "Gas"
        case .carWash: "Car wash"
        }
    }

    /// Shown under the row so the user knows why a hardware store is in a list
    /// of car places.
    var whyItsHere: String? {
        switch self {
        case .hardwareStore: "Tools and bolts — usually cheaper here"
        default: nil
        }
    }
}
