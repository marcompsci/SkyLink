import SwiftUI

@main
struct SkyLinkApp: App {
    @State private var garage = GarageStore()
    @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(garage)
                .environment(router)
                .preferredColorScheme(.dark)
                .onOpenURL(perform: router.open)
        }
    }
}
