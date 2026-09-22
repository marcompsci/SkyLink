import Foundation
import WidgetKit

/// Reads and writes the widget-visible snapshot in the App Group container.
///
/// Deliberately small. The vault key never passes through here, and no
/// plaintext private content is stored — the app decides what is safe to
/// publish and writes only that.
enum SharedStore {
    private static let snapshotKey = "dashboard.snapshot.v1"

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
    static func loadSnapshot() -> DashboardSnapshot? {
        guard
            let data = AppGroup.defaults?.data(forKey: snapshotKey),
            let snapshot = try? decoder.decode(DashboardSnapshot.self, from: data)
        else {
            return nil
        }

        return snapshot
    }

    static func save(_ snapshot: DashboardSnapshot) {
        guard let data = try? encoder.encode(snapshot) else { return }

        AppGroup.defaults?.set(data, forKey: snapshotKey)
        WidgetCenter.shared.reloadAllTimelines()
    }

    /// Flips a habit's completion for today and refreshes the widgets.
    ///
    /// This is the only mutation the widget is allowed to make. It is a
    /// low-risk MindFlow action, so it needs no approval step — unlike
    /// calendar writes or deletions, which open the app. See
    /// docs/14-mindflow.md.
    @discardableResult
    static func toggleHabit(id: UUID) -> Bool {
        guard var snapshot = loadSnapshot() else { return false }
        guard let index = snapshot.habits.firstIndex(where: { $0.id == id }) else { return false }

        let wasDone = snapshot.habits[index].isDoneToday
        snapshot.habits[index].isDoneToday = wasDone == false
        snapshot.habits[index].streak += wasDone ? -1 : 1
        snapshot.updatedAt = .now

        save(snapshot)
        return true
    }
}
