import Foundation

/// Everything the widgets are allowed to render, written by the app and read
/// by the widget extension through the shared App Group container.
///
/// The widget process never talks to the network. The app decides what is
/// safe to publish and writes only that.
struct VehicleSnapshot: Codable, Hashable, Sendable {
    var vehicle: VehicleStatus?
    var updatedAt: Date
}
