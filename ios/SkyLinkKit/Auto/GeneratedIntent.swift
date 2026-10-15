import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

#if canImport(FoundationModels)
/// The guided-generation shape the on-device model fills in.
///
/// `@Generable` gives typed Swift output with no JSON parsing. `reasoning` is
/// declared first on purpose: a short analysis field before the short answer
/// fields gives the model room to work before it commits.
@available(iOS 26, *)
@Generable
struct GeneratedIntent {
    @Guide(description: "One sentence on what the user seems to want and how urgent it sounds.")
    var reasoning: String

    @Guide(description: "One of: roadsideEmergency, diagnoseSymptom, howToJob, findPart, findShop, logService, reminderQuestion, smallTalk, unclear")
    var kind: String

    @Guide(description: "One of: safe, soon, limited, stop. Use stop for smoke, fire, collision, brake or steering failure.")
    var urgency: String

    @Guide(description: "The part, system or job they mentioned. Empty if none.")
    var subject: String

    @Guide(description: "One short question if a date, amount or which car is unclear. Empty otherwise.")
    var followUpQuestion: String
}

@available(iOS 26, *)
extension GeneratedIntent {
    var asAutoIntent: AutoIntent {
        AutoIntent(
            kind: AutoIntent.Kind(rawValue: kind) ?? .unclear,
            urgency: DiagnosticSeverity(rawValue: urgency),
            subject: subject.isEmpty ? nil : subject,
            followUpQuestion: followUpQuestion.isEmpty ? nil : followUpQuestion
        )
    }
}
#endif
