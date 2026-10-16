import Observation
import SwiftUI

@MainActor
@Observable
final class AppRouter {
    var path: [Route] = []
    var isDrawerOpen = false

    /// Entry point for `skylink://` URLs from the widget, Siri, or anywhere
    /// else. An unrecognised URL is ignored rather than surfaced — a broken
    /// link should never show an error to someone who may be stranded.
    func open(_ url: URL) {
        guard let route = DeepLink.route(from: url) else { return }
        show(route)
    }

    func show(_ route: Route) {
        isDrawerOpen = false

        // SOS always replaces the stack. Nothing should sit between a
        // stranded user and triage, including their own back history.
        if route == .sos {
            path = [.sos]
            return
        }

        path.append(route)
    }

    func popToRoot() {
        path.removeAll()
    }
}
