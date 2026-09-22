import Foundation

/// The four urgency levels the Diagnostics agent is allowed to return.
///
/// Spec: docs/07-obd-ii.md. A flashing check-engine light is always at
/// least `.limited`.
enum DiagnosticSeverity: String, Codable, Hashable, Sendable, CaseIterable {
    case safe
    case soon
    case limited
    case stop

    var label: String {
        switch self {
        case .safe: "Safe to drive"
        case .soon: "Get it checked soon"
        case .limited: "Don't drive far"
        case .stop: "Stop driving now"
        }
    }

    /// Severity is never communicated by colour alone, so every level
    /// carries a symbol as well as a tint and the label above.
    var symbolName: String {
        switch self {
        case .safe: "checkmark.circle.fill"
        case .soon: "clock.badge.exclamationmark.fill"
        case .limited: "exclamationmark.triangle.fill"
        case .stop: "hand.raised.fill"
        }
    }
}
