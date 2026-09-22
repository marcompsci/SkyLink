import SwiftUI

extension DataFreshness {
    var tint: Color {
        switch self {
        case .live: SkyLinkPalette.safeGreen
        case .manual: .secondary
        case .stale: SkyLinkPalette.cautionAmber
        case .demo: SkyLinkPalette.mindflowOrange
        }
    }
}
