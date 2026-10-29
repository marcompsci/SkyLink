import SwiftUI

/// The two answers to "are you somewhere safe now?".
///
/// Press feedback is deliberately fast and un-bouncy here. Everywhere else a
/// little life is good; on this screen the person is frightened and the
/// controls should feel certain.
struct SOSButtonStyle: ButtonStyle {
    enum Kind {
        case affirm
        case urgent
    }

    let kind: Kind

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.callout, weight: .bold))
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(background, in: .rect(cornerRadius: 15))
            .overlay {
                if kind == .urgent {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(SOSPalette.border, lineWidth: 1.5)
                }
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(SkyMotion.press, value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .medium), trigger: configuration.isPressed) { _, p in p }
    }

    private var foreground: Color {
        kind == .affirm ? SkyLinkPalette.garageBlack : SkyLinkPalette.stopRed
    }

    private var background: Color {
        kind == .affirm ? SkyLinkPalette.safeGreen : SOSPalette.card
    }
}
