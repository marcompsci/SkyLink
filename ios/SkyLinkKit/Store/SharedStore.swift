import Foundation
import WidgetKit

/// Reads and writes the widget-visible snapshot in the App Group container.
///
/// Deliberately small: one value in, one value out. The app owns every
/// decision about what belongs here.
enum SharedStore {
    private static let snapshotKey = "vehicle.snapshot.v1"

    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    /// Returns nil when nothing has been published yet. Callers render an
    /// empty state rather than inventing numbers.
    static func loadSnapshot() -> VehicleSnapshot? {
        guard
            let data = AppGroup.defaults?.data(forKey: snapshotKey),
            let snapshot = try? decoder.decode(VehicleSnapshot.self, from: data)
        else {
            return nil
        }

        return snapshot
    }

    static func save(_ snapshot: VehicleSnapshot) {
        guard let data = try? encoder.encode(snapshot) else { return }

        AppGroup.defaults?.set(data, forKey: snapshotKey)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
