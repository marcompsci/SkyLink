import Foundation

extension VehicleSnapshot {
    /// Used for the widget gallery and SwiftUI previews only.
    ///
    /// Marked `.demo` so it can never be mistaken for real data: the views
    /// read that flag and badge themselves accordingly.
    static var placeholder: VehicleSnapshot {
        VehicleSnapshot(
            vehicle: VehicleStatus(
                nickname: "2016 Civic",
                mileage: 84_210,
                activeCode: "P0301",
                severity: .limited,
                milesToNextService: 290,
                freshness: .demo,
                updatedAt: .now
            ),
            updatedAt: .now
        )
    }
}
