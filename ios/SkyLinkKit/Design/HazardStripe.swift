import SwiftUI

/// The signature motif: 45° Shop Yellow on Garage Black.
///
/// It belongs at the top of a screen and around the SOS button, and nowhere
/// else. Used sparingly it reads as a workshop; used everywhere it reads as a
/// construction site.
struct HazardStripe: View {
    var height: CGFloat = 7

    var body: some View {
        Rectangle()
            .fill(
                .linearGradient(
                    stops: stops,
                    startPoint: .topLeading,
                    endPoint: UnitPoint(x: 0.08, y: 1)
                )
            )
            .frame(height: height)
            .accessibilityHidden(true)
    }

    private var stops: [Gradient.Stop] {
        var result: [Gradient.Stop] = []
        let bands = 24
        for i in 0..<bands {
            let start = Double(i) / Double(bands)
            let end = Double(i + 1) / Double(bands)
            let colour = i.isMultiple(of: 2) ? SkyLinkPalette.shopYellow : SkyLinkPalette.garageBlack
            result.append(.init(color: colour, location: start))
            result.append(.init(color: colour, location: end))
        }
        return result
    }
}
