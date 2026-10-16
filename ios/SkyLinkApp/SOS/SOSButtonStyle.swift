import SwiftUI

struct SOSButtonStyle: ButtonStyle {
    enum Kind {
        case affirm
        case urgent
    }

    let kind: Kind

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
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
            .opacity(configuration.isPressed ? 0.82 : 1)
    }

    private var foreground: Color {
        kind == .affirm ? SkyLinkPalette.garageBlack : SkyLinkPalette.stopRed
    }

    private var background: Color {
        kind == .affirm ? SkyLinkPalette.safeGreen : SOSPalette.card
    }
}
