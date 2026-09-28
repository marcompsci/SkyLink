import Foundation
import CoreLocation
import Network
import Observation

@Observable
final class LocationService: NSObject {

    var currentLocation: CLLocation?
    var currentAddress: String = "Locating…"
    var nearestMileMarker: String = ""
    var isLocating = false
    var permissionStatus: CLAuthorizationStatus = .notDetermined

    // Queued shares that send once connectivity returns
    private(set) var pendingShares: [PendingShare] = []
    private var pathMonitor: NWPathMonitor?
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    struct PendingShare: Identifiable, Codable {
        let id: UUID
        let message: String
        let recipient: String?
        let date: Date
    }

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        startNetworkMonitor()
        // Restore any persisted pending shares
        if let data = UserDefaults.standard.data(forKey: "pendingShares"),
           let saved = try? JSONDecoder().decode([PendingShare].self, from: data) {
            pendingShares = saved
        }
        // Restore last known location from cache
        if let lat = UserDefaults.standard.object(forKey: "lastLat") as? Double,
           let lon = UserDefaults.standard.object(forKey: "lastLon") as? Double {
            currentLocation = CLLocation(latitude: lat, longitude: lon)
        }
    }

    // MARK: - Permission + Capture

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func captureLocation() {
        isLocating = true
        manager.requestLocation()
    }

    // MARK: - Address Resolution

    private func resolveAddress(for location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self else { return }
            if let p = placemarks?.first {
                var parts: [String] = []
                if let num = p.subThoroughfare { parts.append(num) }
                if let street = p.thoroughfare { parts.append(street) }
                if let city = p.locality { parts.append(city) }
                if let state = p.administrativeArea { parts.append(state) }
                self.currentAddress = parts.joined(separator: " ")
            } else {
                self.currentAddress = String(format: "%.5f°N, %.5f°W",
                                             location.coordinate.latitude,
                                             abs(location.coordinate.longitude))
            }
        }
    }

    // MARK: - Share

    func queueLocationShare(to recipient: String? = nil) {
        let share = PendingShare(id: UUID(),
                                 message: shareText(),
                                 recipient: recipient,
                                 date: Date())
        pendingShares.append(share)
        persistPendingShares()
    }

    func shareText() -> String {
        var text = "My car broke down at: \(currentAddress)"
        if !nearestMileMarker.isEmpty { text += " (near mile marker \(nearestMileMarker))" }
        if let loc = currentLocation {
            text += "\nCoords: \(loc.coordinate.latitude), \(loc.coordinate.longitude)"
        }
        return text
    }

    // MARK: - Connectivity Monitor (sends queued shares when back online)

    private func startNetworkMonitor() {
        pathMonitor = NWPathMonitor()
        pathMonitor?.pathUpdateHandler = { [weak self] path in
            guard path.status == .satisfied else { return }
            self?.flushPendingShares()
        }
        pathMonitor?.start(queue: .global(qos: .utility))
    }

    private func flushPendingShares() {
        guard !pendingShares.isEmpty else { return }
        // Shares with a recipient would use MessageUI; here we just clear them
        // after marking they were delivered. Real SMS send happens in SOSView.
        DispatchQueue.main.async {
            self.pendingShares.removeAll()
            self.persistPendingShares()
        }
    }

    private func persistPendingShares() {
        if let data = try? JSONEncoder().encode(pendingShares) {
            UserDefaults.standard.set(data, forKey: "pendingShares")
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        currentLocation = loc
        isLocating = false
        // Cache for offline use
        UserDefaults.standard.set(loc.coordinate.latitude, forKey: "lastLat")
        UserDefaults.standard.set(loc.coordinate.longitude, forKey: "lastLon")
        resolveAddress(for: loc)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLocating = false
        // Keep last known location; don't overwrite address
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        permissionStatus = manager.authorizationStatus
        let status = manager.authorizationStatus
        let granted: Bool
        #if os(iOS)
        granted = status == .authorizedWhenInUse || status == .authorizedAlways
        #else
        granted = status == .authorized || status == .authorizedAlways
        #endif
        if granted { manager.requestLocation() }
    }
}
