import Foundation

/// Where a value came from and how much to trust it.
///
/// Spec: docs/14-mindflow.md — sample data is never presented as live
/// information, and every connected panel states its source.
enum DataFreshness: String, Codable, Hashable, Sendable {
    /// Fetched from an authorized API inside the freshness window.
    case live

    /// The user typed it.
    case manual

    /// Connection alive, data older than the freshness window.
    case stale

    /// Sample content with no real connection behind it.
    case demo

    /// Short label shown beside the value. Never omitted.
    var label: String {
        switch self {
        case .live: "Live"
        case .manual: "Entered by you"
        case .stale: "Needs refresh"
        case .demo: "Sample data"
        }
    }

    /// Demo data must be unmistakable on every surface it reaches,
    /// widgets included.
    var requiresProminentBadge: Bool {
        self == .demo
    }
}
