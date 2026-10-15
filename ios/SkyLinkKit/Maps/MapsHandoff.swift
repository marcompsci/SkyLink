import Foundation
import MapKit

/// Hands navigation to Apple Maps.
///
/// Why handoff instead of in-app turn-by-turn: in-app guidance means licensing
/// a navigation SDK. Apple Maps is free, already installed, already trusted for
/// driving, handles CarPlay, and is better than anything SkyLink would ship in
/// v1. The user ends up where they need to be, which is the actual goal.
///
/// Auto always asks before calling this. Never a silent redirect out of the app.
enum MapsHandoff {
    @MainActor
    static func openDirections(to place: NearbyPlace) {
        let placemark = MKPlacemark(coordinate: place.coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = place.name

        item.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

    /// Used by Roadside SOS: shows the user's own position so they can read the
    /// address out to a tow operator. Works with a coarse fix.
    @MainActor
    static func openCurrentLocation() {
        MKMapItem.forCurrentLocation().openInMaps()
    }
}
