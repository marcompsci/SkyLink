import WidgetKit

/// Widgets are timeline snapshots on a budgeted refresh, not live views.
///
/// We publish one entry for now and ask the system to come back in fifteen
/// minutes. The app also calls `WidgetCenter.reloadAllTimelines()` whenever
/// it writes, which is what actually keeps this current — the interval is
/// only a floor.
struct HabitsProvider: TimelineProvider {
    func placeholder(in context: Context) -> HabitsEntry {
        HabitsEntry(date: .now, snapshot: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (HabitsEntry) -> Void) {
        // The widget gallery gets sample data; a real install gets real data
        // or nothing, never sample data dressed up as real.
        let snapshot = context.isPreview ? DashboardSnapshot.placeholder : SharedStore.loadSnapshot()
        completion(HabitsEntry(date: .now, snapshot: snapshot))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HabitsEntry>) -> Void) {
        let entry = HabitsEntry(date: .now, snapshot: SharedStore.loadSnapshot())
        let nextRefresh = Date.now.addingTimeInterval(15 * 60)
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }
}
