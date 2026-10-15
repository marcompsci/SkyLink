import Foundation

/// Routes each request to the right model.
///
/// The split, from docs/14-auto-the-mechanic.md:
///
/// - **On-device (Apple Intelligence)** — hearing the user, parsing intent,
///   classifying urgency, summarizing their own service log. Free, private,
///   offline, ~4k token context, no automotive knowledge worth trusting.
/// - **Server** — every automotive fact: diagnosis, torque specs, capacities,
///   part numbers, guide retrieval. Cited and metered.
///
/// The on-device model must never produce a spec, a capacity, a part number or
/// a diagnosis. It has no reliable automotive knowledge and would state one
/// confidently. That is the single rule this type exists to enforce.
protocol AutoBrain: Sendable {
    var availability: AutoBrainAvailability { get async }

    /// Language work only: what did they ask for?
    func parseIntent(from utterance: String) async throws -> AutoIntent

    /// Language work only: condense text the app already has.
    func summarize(_ text: String, maxWords: Int) async throws -> String
}

/// Tasks that are never allowed on the on-device path.
///
/// Documented as a type so the rule is greppable and testable rather than a
/// comment someone can miss.
enum ServerOnlyTask: String, CaseIterable, Sendable {
    case torqueSpec
    case fluidCapacity
    case partNumber
    case serviceInterval
    case diagnosis
    case repairCostEstimate
    case guideRetrieval
}
