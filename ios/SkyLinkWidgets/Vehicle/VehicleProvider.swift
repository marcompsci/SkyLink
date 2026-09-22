import WidgetKit

struct VehicleProvider: TimelineProvider {
    func placeholder(in context: Context) -> VehicleEntry {
        VehicleEntry(date: .now, vehicle: DashboardSnapshot.placeholder.vehicle)
    }

    func getSnapshot(in context: Context, completion: @escaping (VehicleEntry) -> Void) {
        let vehicle = context.isPreview
            ? DashboardSnapshot.placeholder.vehicle
            : SharedStore.loadSnapshot()?.vehicle

        completion(VehicleEntry(date: .now, vehicle: vehicle))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VehicleEntry>) -> Void) {
        let entry = VehicleEntry(date: .now, vehicle: SharedStore.loadSnapshot()?.vehicle)
        let nextRefresh = Date.now.addingTimeInterval(30 * 60)
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }
}
