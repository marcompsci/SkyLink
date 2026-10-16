import SwiftUI

/// An honest placeholder. M0 ships the shell; guides, categories and Ask Auto
/// are M1 and M5 in docs/12-roadmap.md.
///
/// Better than a screen that pretends to work: anyone opening this build knows
/// exactly where the edge is.
struct NotBuiltYetView: View {
    var body: some View {
        VStack(spacing: 16) {
            AutoSpriteView(state: .cantHelp, size: 96)

            Text("Not built yet")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(SkyLinkPalette.chrome)

            Text("This is the M0 shell. Guides and Ask Auto come next.")
                .font(.system(size: 14))
                .foregroundStyle(SkyLinkPalette.grease)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SkyLinkPalette.garageBlack)
    }
}

#Preview {
    NotBuiltYetView()
}
