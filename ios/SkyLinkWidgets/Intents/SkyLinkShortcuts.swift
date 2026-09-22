import AppIntents

/// Registers the phrases Siri recognises. `applicationName` resolves to the
/// app's display name, so these read as "Log a habit in SkyLink".
struct SkyLinkShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LogHabitIntent(),
            phrases: [
                "Log a habit in \(.applicationName)",
                "Mark my habit done in \(.applicationName)"
            ],
            shortTitle: "Log a habit",
            systemImageName: "checkmark.circle"
        )
    }
}
