import Foundation

extension AutoState {
    /// Maps a diagnostic severity onto Auto's face, so one source of truth
    /// drives the colour, the word, the icon and the expression.
    init(severity: DiagnosticSeverity) {
        switch severity {
        case .safe: self = .foundIt
        case .soon, .limited: self = .careful
        case .stop: self = .stop
        }
    }
}
