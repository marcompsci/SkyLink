import SwiftUI

/// Tokens from design/tokens.json, kept in one place so the widgets and
/// the app cannot drift apart.
enum SkyLinkPalette {
    static let signalTeal = Color(red: 0.235, green: 0.878, blue: 0.788)
    static let midnight = Color(red: 0.039, green: 0.059, blue: 0.102)
    static let coral = Color(red: 1.0, green: 0.478, blue: 0.416)
    static let stopRed = Color(red: 0.878, green: 0.235, blue: 0.235)
    static let cautionAmber = Color(red: 0.949, green: 0.694, blue: 0.220)
    static let safeGreen = Color(red: 0.235, green: 0.796, blue: 0.498)

    static let mindflowCream = Color(red: 0.984, green: 0.957, blue: 0.894)
    static let mindflowInk = Color(red: 0.090, green: 0.090, blue: 0.059)
    static let mindflowBlue = Color(red: 0.106, green: 0.231, blue: 0.878)
    static let mindflowOrange = Color(red: 1.0, green: 0.353, blue: 0.169)
    static let mindflowYellow = Color(red: 1.0, green: 0.827, blue: 0.306)
}
