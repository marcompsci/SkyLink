import SwiftUI

extension DiagnosticSeverity {
    /// Paired with `symbolName` and `label` — never used on its own,
    /// because colour alone is not an accessible signal.
    var tint: Color {
        switch self {
        case .safe: SkyLinkPalette.safeGreen
        case .soon: SkyLinkPalette.coral
        case .limited: SkyLinkPalette.cautionAmber
        case .stop: SkyLinkPalette.stopRed
        }
    }
}
