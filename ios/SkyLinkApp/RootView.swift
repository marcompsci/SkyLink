import SwiftUI

struct RootView: View {
    @Environment(AppRouter.self) private var router

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
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.snappy(duration: 0.22), value: router.isDrawerOpen)
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
