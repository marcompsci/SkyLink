import Foundation

/// The App Group shared between the app and the widget extension.
///
/// This string must match `com.apple.security.application-groups` in BOTH
/// targets' entitlements. If they disagree the widget shows an empty state
/// forever and nothing tells you why — see ios/BUILD.md.
enum AppGroup {
    static let identifier = "group.com.phoronomics.skylink.shared"

    static var defaults: UserDefaults? {
        UserDefaults(suiteName: identifier)
    }
}
