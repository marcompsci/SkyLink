import Foundation

/// What the user actually wants, extracted from whatever they said.
///
/// This is the output of the on-device pass. Classification and extraction are
/// what the small model is genuinely good at; the answer itself is not.
struct AutoIntent: Codable, Hashable, Sendable {
    enum Kind: String, Codable, Sendable {
        case roadsideEmergency
        case diagnoseSymptom
        case howToJob
        case findPart
        case findShop
        case logService
        case reminderQuestion
        case smallTalk
        case unclear
    }

    var kind: Kind
    var urgency: DiagnosticSeverity?
    var subject: String?
    var followUpQuestion: String?

    /// Anything alarming routes to Roadside before diagnosis, per the
    /// orchestrator rules in docs/08-ai-agents.md.
    var needsRoadsideFirst: Bool {
        kind == .roadsideEmergency || urgency == .stop
    }
}
