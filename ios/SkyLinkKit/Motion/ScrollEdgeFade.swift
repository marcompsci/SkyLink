import SwiftUI

/// A soft edge where content passes under chrome, instead of a 1px rule.
///
/// Hard dividers announce that two things are separate. A fade says content
/// continues underneath, which is what is actually happening — and it is the
/// difference between chrome that sits *on* the screen and chrome that sits
/// *above* the content.
struct ScrollEdgeFade: View {
    var edge: VerticalEdge = .bottom
    var height: CGFloat = 20

    var body: some View {
        LinearGradient(
            colors: [SkyLinkPalette.garageBlack.opacity(0), SkyLinkPalette.garageBlack],
            startPoint: edge == .bottom ? .top : .bottom,
            endPoint: edge == .bottom ? .bottom : .top
        )
        .frame(height: height)
        .allowsHitTesting(false)
    }
}
