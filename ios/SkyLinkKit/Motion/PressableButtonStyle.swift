import SwiftUI

/// Responds on press-down, not on release.
///
/// `.buttonStyle(.plain)` gives no feedback at all — the button is inert until
/// the finger lifts and something else happens. That half-second of nothing is
/// most of what makes an interface feel dead. This highlights the instant the
/// finger lands, and carries a light haptic on the same frame as the visual,
/// so the two read as one event.
struct PressableButtonStyle: ButtonStyle {
    /// Large surfaces move less. A full-width card scaling 3% looks broken;
    /// a small chip scaling 3% looks responsive.
    enum Weight {
        case card
        case control

        var scale: CGFloat {
            switch self {
            case .card: 0.985
            case .control: 0.96
            }
        }
    }

    var weight: Weight = .control
    var dims: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? weight.scale : 1)
            .opacity(configuration.isPressed && dims ? 0.86 : 1)
            .animation(SkyMotion.press, value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed) { _, pressed in
                pressed
            }
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    /// For cards and rows.
    static var card: PressableButtonStyle { PressableButtonStyle(weight: .card) }
    /// For buttons, chips and icon controls.
    static var control: PressableButtonStyle { PressableButtonStyle(weight: .control) }
}
