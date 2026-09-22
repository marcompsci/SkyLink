import Foundation

/// The App Group shared between the app and the widget extension.
///
/// Set this identifier in Signing & Capabilities on BOTH targets, then
/// replace the value below. Nothing is read or written until it matches.
enum AppGroup {
    static let identifier = "group.com.skylink.shared"

    static var defaults: UserDefaults? {
        UserDefaults(suiteName: identifier)
    }
}
