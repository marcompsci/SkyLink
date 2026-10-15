import Foundation

/// Auto's seven states. He is a state machine with a face, not an animation reel.
///
/// Spec: docs/14-auto-the-mechanic.md. `careful` and `stop` are the visual half
/// of the severity system — they never appear without the matching word and icon.
enum AutoState: String, Codable, Hashable, Sendable, CaseIterable {
    case idle
    case listening
    case thinking
    case foundIt
    case careful
    case stop
    case cantHelp

    /// The word that must accompany the expression. Colour and face are never
    /// the only signal.
    var label: String {
        switch self {
        case .idle: "Ready"
        case .listening: "Listening"
        case .thinking: "Working on it"
        case .foundIt: "Here's what I found"
        case .careful: "Careful"
        case .stop: "Stop"
        case .cantHelp: "I can't help with this one"
        }
    }

    var symbolName: String {
        switch self {
        case .idle: "wrench.adjustable"
        case .listening: "mic.fill"
        case .thinking: "ellipsis"
        case .foundIt: "checkmark.circle.fill"
        case .careful: "exclamationmark.triangle.fill"
        case .stop: "hand.raised.fill"
        case .cantHelp: "questionmark.circle"
        }
    }
}
