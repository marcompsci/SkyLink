import Foundation
import MapKit

/// Finds shops and stores around the user's current location.
///
/// `MKLocalSearch` is free and needs no API key, which is why v1 uses it
/// rather than a paid places provider.
struct NearbyPlaceFinder: Sendable {
    func search(
        for kind: NearbyPlaceKind,
        near center: CLLocationCoordinate2D,
        radiusMeters: CLLocationDistance = 8_000,
        limit: Int = 5
    ) async throws -> [NearbyPlace] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = kind.searchTerm
        request.region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: radiusMeters * 2,
            longitudinalMeters: radiusMeters * 2
        )

        let response = try await MKLocalSearch(request: request).start()
        let origin = CLLocation(latitude: center.latitude, longitude: center.longitude)

        return response.mapItems.prefix(limit).map { item in
            let itemLocation = CLLocation(
                latitude: item.placemark.coordinate.latitude,
                longitude: item.placemark.coordinate.longitude
            )

            return NearbyPlace(
                id: UUID(),
                name: item.name ?? kind.label,
                coordinate: item.placemark.coordinate,
                distanceMeters: origin.distance(from: itemLocation),
                phoneNumber: item.phoneNumber,
                kind: kind
            )
        }
        .sorted { $0.distanceMeters < $1.distanceMeters }
    }
}
