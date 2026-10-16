import SwiftUI

/// Tokens from design/tokens.json, in one place so the app and the widgets
/// cannot drift apart.
///
/// Pocket garage: a tool chest, not a dashboard. Deep charcoal, chrome,
/// hazard stripes, and one hot accent that carries every action.
enum SkyLinkPalette {
    /// Ground.
    static let garageBlack = Color(red: 0.071, green: 0.078, blue: 0.098)
    /// Cards and raised surfaces.
    static let steel = Color(red: 0.110, green: 0.125, blue: 0.157)
    /// Primary text and diagram line work.
    static let chrome = Color(red: 0.867, green: 0.890, blue: 0.918)
    /// The only primary action colour. Two orange things on one screen means
    /// one of them is wrong.
    static let torqueOrange = Color(red: 1.0, green: 0.420, blue: 0.173)
    /// Hazard stripes, caution, "get it checked soon".
    static let shopYellow = Color(red: 1.0, green: 0.773, blue: 0.239)
    /// Secondary action, "safe to drive", completed steps.
    static let oilTeal = Color(red: 0.098, green: 0.765, blue: 0.698)
    /// SOS and "stop driving now".
    static let stopRed = Color(red: 0.910, green: 0.251, blue: 0.165)
    /// Confirmations and passed checks.
    static let safeGreen = Color(red: 0.243, green: 0.812, blue: 0.557)
    /// Secondary text, dimmed diagram layers.
    static let grease = Color(red: 0.420, green: 0.455, blue: 0.502)
}
