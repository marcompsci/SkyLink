import SwiftUI
import SwiftData

@main
struct SkyLinkApp: App {

    @State private var appEnv = AppEnvironment()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Vehicle.self,
            FaultCode.self,
            SOSSession.self,
            MindFlowEntry.self,
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(appEnv)
        }
        .modelContainer(sharedModelContainer)
    }
}
