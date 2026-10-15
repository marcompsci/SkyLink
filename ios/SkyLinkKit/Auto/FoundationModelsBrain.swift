import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

/// The on-device half of Auto, built on Apple's Foundation Models framework.
///
/// Three things shape this implementation, all from Apple's documented limits:
///
/// 1. **Availability is checked every time.** The model can be unavailable
///    because the device is ineligible, the feature is off, or the model isn't
///    downloaded — and the framework may add reasons. Every path falls through
///    to the server rather than surfacing an error.
/// 2. **Context is ~4,096 tokens for input and output combined.** Prompts stay
///    short and nothing long is ever sent here.
/// 3. **The safety guardrails produce false positives**, and automotive
///    language is full of trigger words — "bleed the brakes", "kill the
///    engine", "blew the head gasket". A guardrail rejection is treated as a
///    routing signal, not a failure.
///
/// Apple can also update the model without a version pin, so nothing
/// safety-critical is decided here.
struct FoundationModelsBrain: AutoBrain {
    /// Developer-authored only. User text is never concatenated into this.
    private static let instructions = """
    You work for a car-repair app. Your only job is to classify what the user \
    is asking for and extract the subject of their question.

    Never answer the automotive question. Never state a torque spec, a fluid \
    capacity, a part number, a service interval, or a diagnosis — another \
    system does that with cited sources.

    If the user describes smoke, fire, a collision, brake failure, steering \
    loss, or being stranded, set kind to roadsideEmergency and urgency to stop.

    If a date, amount, or which car they mean is unclear, put one short \
    question in followUpQuestion.
    """

    var availability: AutoBrainAvailability {
        get async {
            #if canImport(FoundationModels)
            guard #available(iOS 26, *) else {
                return .serverOnly(reason: .osTooOld)
            }

            switch SystemLanguageModel.default.availability {
            case .available:
                return .onDevice
            case .unavailable(.deviceNotEligible):
                return .serverOnly(reason: .deviceNotEligible)
            case .unavailable(.appleIntelligenceNotEnabled):
                return .serverOnly(reason: .appleIntelligenceNotEnabled)
            case .unavailable(.modelNotReady):
                return .serverOnly(reason: .modelNotReady)
            @unknown default:
                // The framework is young; new reasons will appear.
                return .serverOnly(reason: .unknown)
            }
            #else
            return .serverOnly(reason: .osTooOld)
            #endif
        }
    }

    func parseIntent(from utterance: String) async throws -> AutoIntent {
        #if canImport(FoundationModels)
        guard #available(iOS 26, *), await availability.canUseOnDevice else {
            throw AutoBrainError.onDeviceUnavailable
        }

        let session = LanguageModelSession(instructions: Self.instructions)

        do {
            let response = try await session.respond(
                to: utterance,
                generating: GeneratedIntent.self
            )

            return response.content.asAutoIntent
        } catch {
            // Includes guardrail rejections. Route to the server instead.
            throw AutoBrainError.guardrailOrGenerationFailed
        }
        #else
        throw AutoBrainError.onDeviceUnavailable
        #endif
    }

    func summarize(_ text: String, maxWords: Int) async throws -> String {
        #if canImport(FoundationModels)
        guard #available(iOS 26, *), await availability.canUseOnDevice else {
            throw AutoBrainError.onDeviceUnavailable
        }

        let session = LanguageModelSession(
            instructions: "Summarize the text the app gives you. Add nothing that is not in it."
        )

        let response = try await session.respond(
            to: "In \(maxWords) words or fewer:\n\n\(text)"
        )

        return response.content
        #else
        throw AutoBrainError.onDeviceUnavailable
        #endif
    }
}
