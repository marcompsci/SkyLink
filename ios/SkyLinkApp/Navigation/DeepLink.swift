import Foundation

/// `skylink://` URLs, the only ones the app answers to.
///
/// `skylink://sos` is the one that matters: the widget and the Siri intent
/// both use it, and it must land on triage with no intermediate screen.
enum DeepLink {
    static let scheme = "skylink"

    static func route(from url: URL) -> Route? {
        guard url.scheme == scheme else { return nil }

        var parts: [String] = []
        if let host = url.host, !host.isEmpty { parts.append(host) }
        parts += url.pathComponents.filter { $0 != "/" && !$0.isEmpty }

        switch parts.first {
        case "sos":
            return .sos
        case "guide":
            guard parts.count > 1 else { return nil }
            return .guide(slug: parts[1])
        case "category":
            guard parts.count > 1 else { return nil }
            return .category(slug: parts[1])
        case "log":
            return .serviceLog
        case "ask":
            return .askAuto
        default:
            return nil
        }
    }
}
