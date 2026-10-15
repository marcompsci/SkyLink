import CoreLocation

/// SkyLink asks for **While Using the App**, never Always.
///
/// Finding a shop is something you do deliberately, with the app open. Apple
/// requires a clear user-visible benefit for Always-on location and rejects
/// apps that request it for features that work fine in the foreground.
///
/// The only defensible case for Always is automatic breakdown detection for
/// SOS, which would be a separate feature with its own explanation screen.
@MainActor
final class LocationAuthorization: NSObject, ObservableObject {
    @Published private(set) var status: CLAuthorizationStatus
    @Published private(set) var lastFix: CLLocation?

    private let manager = CLLocationManager()

    override init() {
        status = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    /// Call this only after the app has explained, in Auto's voice, what the
    /// permission is for. Never on launch.
    func requestWhenInUse() {
        manager.requestWhenInUseAuthorization()
    }

    func requestOneFix() {
        guard status == .authorizedWhenInUse || status == .authorizedAlways else { return }
        manager.requestLocation()
    }

    /// Declining is a supported path, not an error: the user types a ZIP and
    /// everything except live distances still works.
    var canUseLiveLocation: Bool {
        status == .authorizedWhenInUse || status == .authorizedAlways
    }
}

extension LocationAuthorization: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        status = manager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastFix = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Silent: the ZIP-code path covers this.
    }
}
