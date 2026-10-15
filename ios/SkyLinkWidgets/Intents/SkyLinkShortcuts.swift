import AppIntents

/// Registers the phrases Siri recognises. `applicationName` resolves to the
/// app's display name, so these read as "roadside help in SkyLink".
struct SkyLinkShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenRoadsideIntent(),
            phrases: [
                "Roadside help in \(.applicationName)",
                "I'm stranded in \(.applicationName)",
                "\(.applicationName) emergency"
            ],
            shortTitle: "Roadside help",
            systemImageName: "exclamationmark.triangle.fill"
        )
    }
}
