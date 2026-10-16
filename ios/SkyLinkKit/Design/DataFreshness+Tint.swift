import SwiftUI

extension DataFreshness {
    var tint: Color {
        switch self {
        case .live: SkyLinkPalette.safeGreen
        case .manual: SkyLinkPalette.grease
        case .stale: SkyLinkPalette.shopYellow
        case .demo: SkyLinkPalette.torqueOrange
        }
    }
}
