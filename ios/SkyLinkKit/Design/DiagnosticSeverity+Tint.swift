import SwiftUI

extension DiagnosticSeverity {
    /// Paired with `symbolName` and `label` — never used alone, because colour
    /// is not an accessible signal by itself.
    var tint: Color {
        switch self {
        case .safe: SkyLinkPalette.safeGreen
        case .soon: SkyLinkPalette.shopYellow
        case .limited: SkyLinkPalette.torqueOrange
        case .stop: SkyLinkPalette.stopRed
        }
    }
}
