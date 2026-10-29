import SwiftUI

struct RootView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            GarageView()
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
        .tint(SkyLinkPalette.torqueOrange)
        .overlay(alignment: .leading) {
            if router.isDrawerOpen {
                DrawerView()
                    // Enters and leaves along the same path it is dragged
                    // along. Reduced motion gets a cross-fade instead.
                    .transition(
                        reduceMotion
                            ? .opacity
                            : .move(edge: .leading).combined(with: .opacity)
                    )
            }
        }
        .animation(SkyMotion.respecting(reduceMotion, SkyMotion.drawer), value: router.isDrawerOpen)
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .sos:
            SOSView()
        case .serviceLog:
            ServiceLogView()
        case .askAuto, .guide, .category:
            NotBuiltYetView()
        }
    }
}
