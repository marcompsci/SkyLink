import Foundation

struct VehicleStatus: Codable, Hashable, Sendable {
    var nickname: String
    var mileage: Int
    var activeCode: String?
    var severity: DiagnosticSeverity?
    var milesToNextService: Int?
    var freshness: DataFreshness
    var updatedAt: Date
}
