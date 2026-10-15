import AppIntents

/// "Hey Siri, roadside help in SkyLink."
///
/// Opens the app rather than acting in the background: the safety script and
/// the location capture belong in the full flow, and someone who needs this
/// is not in a position to read a confirmation dialog. Siri is an entry
/// point, never a shortcut past the triage.
struct OpenRoadsideIntent: AppIntent {
    static let title: LocalizedStringResource = "Get roadside help"
    static let description = IntentDescription("Opens SkyLink's roadside triage.")
    static let openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        .result()
    }
}
